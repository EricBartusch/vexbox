extends Control

var boxScene = preload("res://Box.tscn")
var statusScene = preload("res://StatusEffect.tscn")
var logEntryScene = preload("res://LogEntry.tscn")

var PYRAMID_START_X = 760
var PYRAMID_START_Y = 105

var boxes = []
var rows = []
var totalRows = ((-1 + sqrt(1+(BoxTypes.MAX * 8))) / 2) - 1

var gameRunning = true
var won = false
var lost = false
var opens = 0
var wins = 0
var winstreak = 0
var bestWinstreak = 0
var instantLosses = 0
var rng = RandomNumberGenerator.new()
var resetTimer = 0
var last_opened

func _ready():
	startGame()

func startGame():
	last_opened = null
	won = false
	lost = false
	$ColorRect.color = Color("4f4f4f")
	for node in $LogContainer.get_children():
		$LogContainer.remove_child(node)
		node.queue_free()
	$MusicPlayer.stop()
	awaiting_post_click = false
	opens = 0
	for node in boxes:
		remove_child(node)
		node.queue_free()
	rows.clear()
	boxes.clear()
	gameRunning = true
	$GameStatusText.text =""
	for node in $StatusList.get_children():
		$StatusList.remove_child(node)
		node.queue_free()
	var list = []
	for i in BoxTypes.MAX:
		list.append(i)
	randomize()
	list.shuffle()
	var row = 0
	var column = 0
	var curRow = []
	while (list.size() > 0):
		var next = list[0]
		var instance = boxScene.instantiate()
		instance.load(next, row, column)
		add_child(instance)
		boxes.append(instance)
		curRow.append(instance)
		(instance as Control).global_position = Vector2(PYRAMID_START_X - ((column * 75)) + (75/2 * row-1), PYRAMID_START_Y + (row * 75))
		column += 1
		if column > row:
			column = 0
			row += 1
			rows.append(curRow)
			curRow = []
		list.erase(next)
	
	for badge in $BadgeList.get_children():
		badge.onRunStart()
	update_stat_texts()

func reveal_random():
	var validBoxes = []
	for i in boxes:
		if (!i.revealed && !i.destroyed):
			validBoxes.append(i)
	if !validBoxes.size() == 0:
		var result = validBoxes.pick_random()
		result.revealBox()

func reveal_row(row):
	for box in rows[row]:
		box.revealBox()

func reveal_corners():
	boxes[0].revealBox()
	var bottomrow = totalRows
	var made_change = true
	while made_change:
		var valid_corner = true
		if rows[bottomrow][0].destroyed:
			valid_corner = false
		if rows[bottomrow][bottomrow].destroyed:
			valid_corner = false
		if !valid_corner:
			made_change = true
			bottomrow -= 1
		else:
			made_change = false
	rows[bottomrow][0].revealBox()
	rows[bottomrow][bottomrow].revealBox()

func add_status(statusType, amount):
	if has_status(statusType):
		change_status_amount(statusType, amount)
	else:
		var instance = statusScene.instantiate()
		instance.setup(statusType, amount)
		$StatusList.add_child(instance)

func trigger_on_click():
	for status in $StatusList.get_children():
		status.on_click()
	for box in boxes:
		box.on_click()

func has_status(type):
	for status in $StatusList.get_children():
		if status.type == type:
			return true
	return false

func remove_status(type):
	for status in $StatusList.get_children():
		if status.type == type:
			$StatusList.remove_child(status)
			break

func status_amount(type):
	for status in $StatusList.get_children():
		if status.type == type:
			return status.value
	return 0

func change_status_amount(type, mod):
	for status in $StatusList.get_children():
		if status.type == type:
			status.changeValue(mod)

func destroy_box(box):
	box.destroyBox()

func _on_restart_button_button_up() -> void:
	if won or lost:
		startGame()
	else:
		resetGame()

var awaiting_post_click = false

func await_postclick():
	opens += 1
	awaiting_post_click = true
	$TriggerPostClicksTimer.start()

func _on_trigger_post_clicks_timer_timeout() -> void:
	if gameRunning:
		awaiting_post_click = false
		trigger_on_click()
		update_stat_texts()

func update_stat_texts():
	update_open_text()
	update_destroyed_text()

func update_open_text():
	var open = 0
	for box in boxes:
		if box.open and not box.destroyed:
			open += 1
	$CurOpenText.text = "Currently Open: " + str(open)

func update_destroyed_text():
	var destroyed = 0
	for box in boxes:
		if box.destroyed:
			destroyed += 1
	$CurDestroyedText.text = "Currently Destroyed: " + str(destroyed)

func internal_win():
	won = true
	$ColorRect.color = Color(0.2, 0.33, 0.2, 1)
	logToLog(null, "You won!")
	gameRunning = false
	instantLosses = 0
	$GameStatusText.text = "You won!"
	wins += 1
	winstreak += 1
	$NumWinsText.text = "Wins: " + str(wins)
	$WinstreakText.text = "Winstreak: " + str(winstreak)
	if (winstreak > bestWinstreak):
		bestWinstreak = winstreak;
		$BestWinstreakText.text = "Best Winstreak: " + str(bestWinstreak)
	for badge in $BadgeList.get_children():
		badge.checkWins()

func reset_winstreak():
	winstreak = 0
	$WinstreakText.text = "Winstreak: " + str(winstreak)

func internal_loss():
	lost = true
	$ColorRect.color = Color(0.33, 0.2, 0.2, 1)
	logToLog(null, "You lost!")
	gameRunning = false
	$GameStatusText.text = "You lost."
	reset_winstreak()
	if opens == 0:
		instantLosses += 1
		if instantLosses == 2:
			$BadgeList/LossesToWins.unlockBadge()
	else:
		instantLosses = 0

func win():
	if gameRunning:
		if has_status(StatusTypes.CURSE):
			logToLog(null, "Curse prevented your victory.")
			change_status_amount(StatusTypes.CURSE, -1)
		else:
			if has_status(StatusTypes.INVERSION):
				qLog("You win - but it's inverted to a loss!")
				internal_loss()
			else:
				internal_win()

func lose():
	if gameRunning:
		if !has_status(StatusTypes.HEART):
			if has_status(StatusTypes.INVERSION):
				qLog("You lose - but it's inverted to a win!")
				internal_win()
			else:
				internal_loss()
		else:
			logToLog(null, "Heart prevented your loss!")

func _process(delta: float) -> void:
	if resetTimer > 0:
		resetTimer -= delta

func logToLog(sourceImg, sourceText):
	var newLogEntry = logEntryScene.instantiate()
	newLogEntry.load(sourceImg, sourceText)
	var prevEntries = $LogContainer.get_children()
	if prevEntries.size() >= 10:
		$LogContainer.remove_child(prevEntries[0])
	$LogContainer.add_child(newLogEntry)

func qLog(sourceText):
	logToLog(null, sourceText)

func get_random_box():
	var valids = []
	for box in boxes:
		if !box.destroyed:
			valids.append(box)
	return valids.pick_random()

func clear_central():
	for x in rows.size():
		if x != rows.size()-1:
			for i in rows[x].size():
				if (i != 0 and i != rows[x].size()-1):
					if !rows[x][i].destroyed:
						destroy_box(rows[x][i])

func resetGame():
	if resetTimer <= 0:
		resetTimer = 1
		reset_winstreak()
		startGame()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and (event.keycode == KEY_S or event.keycode == KEY_Q or event.keycode == KEY_W or event.keycode == KEY_A):
		if won or lost:
			startGame()
		else:
			resetGame()

func destroy_bottom_two_rows():
	for box in rows[totalRows]:
		destroy_box(box)
	for box in rows[totalRows-1]:
		destroy_box(box)
