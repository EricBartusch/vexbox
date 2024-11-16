class_name Main extends Control

var boxScene = preload("res://Box.tscn")
var statusScene = preload("res://StatusEffect.tscn")
var logEntryScene = preload("res://LogEntry.tscn")

var PYRAMID_START_X = 760
var PYRAMID_START_Y = 100

var boxes = []
var rows = []
var all_boxes: Array[String] = load("res://boxes.tres").boxes
var MAX_ROWS = ((-1 + sqrt(1+(len(all_boxes) * 8))) / 2) - 1
var unlockedRows = 1
var unlockedBoxes = (unlockedRows * (unlockedRows + 1)) / 2
var winsToNext = 1
var vfxList = []

var gameRunning = true
var won = false
var lost = false
var opens = 0
var wins = 0
var winstreak = 0
var bestWinstreak = 0
var rng = RandomNumberGenerator.new()
var resetTimer = 0
var last_opened: Box
var pan_x = 0
var pan_y = 0

var PAN_MIN_X = -500
var PAN_MIN_Y = -500
var PAN_MAX_X = 500
var PAN_MAX_Y = 500

var statsMap = {}

func _init() -> void:
	Box.main = self
	Badge.main = self

func setupStatsMap():
	for box in all_boxes:
		statsMap[box] = {"opens": 0}

func addVfx(vfx):
	add_child(vfx)
	vfxList.append(vfx)

func removeVfx(vfx):
	remove_child(vfx)
	vfxList.erase(vfx)
	vfx.queue_free()

func save():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict = {
		"wins": wins,
		"winstreak": winstreak,
		"bestWinstreak": bestWinstreak,
		"unlockedRows": unlockedRows,
		"winsToNext": winsToNext,
		"statsMap": statsMap
	}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)

func init_save():
	setupStatsMap()

func load_save():
	if not FileAccess.file_exists("user://savegame.save"):
		init_save()
		return
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var line = save_file.get_line()
	var json = JSON.new()
	
	var parse_result = json.parse(line)
	
	var data = json.data
	for key in data.keys():
			set(key, data[key])
	
	unlockedBoxes = (unlockedRows * (unlockedRows + 1)) / 2

func _ready():
	load_save()
	startGame()
	$WinsToNextText.text = "Reach " + str(winsToNext) + " wins for a NEW ROW."

var loadingGame = false

func startGame():
	var start = Time.get_ticks_usec()
	loadingGame = true
	if curBossfightStatus != null:
		cleanBoss()
	for item in vfxList:
		if is_instance_valid(item):
			remove_child(item)
			item.queue_free()
	vfxList.clear()
	$GameStatusSubtext.visible = false
	last_opened = null
	won = false
	lost = false
	$ColorRect.color = Color("4f4f4f")
	for node in $ScrollContainer/LogContainer.get_children():
		$ScrollContainer/LogContainer.remove_child(node)
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
	for i in unlockedBoxes:
		list.append(all_boxes[i])
	randomize()
	list.shuffle()
	var row = 0
	var column = 0
	var curRow = []
	while not list.is_empty():
		var instance = boxScene.instantiate()
		instance.load(list.pop_front(), row, column)
		add_child(instance)
		boxes.append(instance)
		curRow.append(instance)
		(instance as Control).global_position = Vector2(PYRAMID_START_X - ((column * 75)) + (75/2 * row-1), PYRAMID_START_Y + (row * 75))
		instance.origPosX = instance.global_position.x
		instance.origPosY = instance.global_position.y
		instance.global_position.x += pan_x
		instance.global_position.y += pan_y
		column += 1
		if column > row:
			column = 0
			row += 1
			rows.append(curRow)
			curRow = []
	update_stat_texts()
	loadingGame = false
	var end = Time.get_ticks_usec()
	var worker_time = (end-start)/1000000.0	
	print(worker_time)

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
	var bottomrow = unlockedRows - 1
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
		if box.open and not box.just_opened and not box.destroyed and gameRunning:
			box.on_other_box_opened(last_opened)
		box.just_opened = false
	for box in boxes:
		if box.id == "virus":
			box.thing = 0

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

func after_game_over():
	save()
	$GameStatusSubtext.visible = true

func fib(idx):
	return idx

func internal_win():
	$WinFXPlayer.play()
	won = true
	$ColorRect.color = Color(0.2, 0.33, 0.2, 1)
	logToLog(null, "You won!", null)
	gameRunning = false
	$GameStatusText.text = "You won!"
	wins += 1
	if wins >= winsToNext and unlockedRows < MAX_ROWS:
		unlockedRows += 1
		winsToNext += fib(unlockedRows)
		unlockedBoxes = (unlockedRows * (unlockedRows + 1)) / 2
	$WinsToNextText.text = "Reach " + str(winsToNext) + " wins for the next row."
	winstreak += 1
	$NumWinsText.text = ": " + str(wins)
	$WinstreakText.text = "Winstreak: " + str(winstreak)
	if (winstreak > bestWinstreak):
		bestWinstreak = winstreak;
		$BestWinstreakText.text = "Best Winstreak: " + str(bestWinstreak)
	for badge in $AchievementsContainer.get_children():
		badge.postGameEnd()
	after_game_over()

func reset_winstreak():
	winstreak = 0
	$WinstreakText.text = "Winstreak: " + str(winstreak)

func internal_loss():
	$LossFXPlayer.play()
	lost = true
	$ColorRect.color = Color(0.33, 0.2, 0.2, 1)
	qLog("You lost!")
	gameRunning = false
	$GameStatusText.text = "You lost."
	reset_winstreak()
	after_game_over()

func win():
	if gameRunning:
		if has_status(StatusTypes.CURSE):
			qLog("Curse prevented your victory.")
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
			var willDie = true
			for box in boxes:
				if box.id == "guardian" and !box.destroyed and box.open:
					willDie = false
					box.destroyBox()
					break
			if willDie:
				if has_status(StatusTypes.INVERSION):
					qLog("You lose - but it's inverted to a win!")
					internal_win()
				else:
					internal_loss()
			else:
				qLog("The Extra Life Box saved you!")
		else:
			qLog("Heart prevented your loss!")

var dragCursor = load("res://cursorImgs/cursorDrag.png")
var normalCursor = load("res://cursorImgs/cursorNormal.png")
var fireCursor = load("res://cursorImgs/firecursor.png")

func _process(delta: float) -> void:
	already_played.clear()
	if resetTimer > 0:
		resetTimer -= delta
	if big_bossfight and curBossfightStatus != BossStatus.OUTRO and !lost and !won:
		Input.set_custom_mouse_cursor(fireCursor)
	else:
		if Input.is_action_pressed("pan"):
			Input.set_custom_mouse_cursor(dragCursor)
		else:
			Input.set_custom_mouse_cursor(normalCursor)
	if big_bossfight:
		if showingHealthbars:
			bossHealthbar.global_position.y += delta * 150
			playerHealthbar.global_position.y -= delta * 120
			if bossHealthbar.global_position.y >= 130:
				showingHealthbars = false
				curBossfightStatus = BossStatus.COMBAT
				boss.state = 1
				boss.timer = 0.2

func logToLog(sourceImg, sourceText, ID):
	var newLogEntry = logEntryScene.instantiate()
	newLogEntry.load(sourceImg, sourceText, ID)
	var prevEntries = $ScrollContainer/LogContainer.get_children()
	if prevEntries.size() >= 10:
		$ScrollContainer/LogContainer.remove_child(prevEntries[0])
	$ScrollContainer/LogContainer.add_child(newLogEntry)

func qLog(sourceText):
	logToLog(null, sourceText, null)

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
	if event is InputEventMouseMotion and Input.is_action_pressed("pan") and !big_bossfight:
		var result = event.relative
		pan_x += result.x
		pan_y += result.y
		for item in vfxList:
			item.global_position.x += result.x
			item.global_position.y += result.y
		if pan_x > PAN_MAX_X:
			pan_x = PAN_MAX_X
		if pan_x < PAN_MIN_X:
			pan_x = PAN_MIN_X
		if pan_y > PAN_MAX_Y:
			pan_y = PAN_MAX_Y
		if pan_y < PAN_MIN_Y:
			pan_y = PAN_MIN_Y
		for box in boxes:
			box.global_position.x = box.origPosX + pan_x
			box.global_position.y = box.origPosY + pan_y

var already_played = []

func play_sfx(type):
	if !already_played.has(type):
		match (type):
			SFXTypes.CLOSE:
				$CloseFXPlayer.play()
			SFXTypes.ACTIVATE:
				$ActivateFXPlayer.play()
			SFXTypes.DESTROY:
				$DestroyFXPlayer.play()
			SFXTypes.OPEN:
				$OpenFXPlayer.play()
			SFXTypes.REVEAL:
				$RevealFXPlayer.play()
			SFXTypes.TRANSMOG:
				$TransmogFXPlayer.play()
	already_played.append(type)

var big_bossfight = false

enum BossStatus {
	DROP_BOSS,
	SHOW_HEALTHBARS,
	COMBAT,
	OUTRO
}

var dakka = []

func add_dakka(toAdd):
	toAdd.z_index = 2
	add_child(toAdd)
	dakka.append(toAdd)

var curBossfightStatus
var gameSource
var protag
var boss
var protagScene = preload("res://battle/protag.tscn")
var bossScene = preload("res://battle/boss.tscn")
var healthbarScene = preload("res://battle/healthbar.tscn")
var bossHealthbar
var playerHealthbar : HBoxContainer
var showingHealthbars = false
var heartImg = preload("res://statusImgs/heart.png")
var playerHealth = 3

var startCombatSound = preload("res://sfx/battle/combatstart.ogg")

func start_big_bossfight(source):
	$OneshotSoundPlayer.stream = startCombatSound
	$OneshotSoundPlayer.play()
	$RestartButton.visible = false
	gameSource = source
	source.get_node("Outline").texture = load("res://boxImgs/outlineClosed.png")
	big_bossfight = true
	curBossfightStatus = BossStatus.DROP_BOSS
	var newChar = protagScene.instantiate()
	newChar.global_position.x = source.global_position.x
	newChar.global_position.y = source.global_position.y
	var newBoss = bossScene.instantiate()
	newBoss.global_position.x = 1600
	newBoss.global_position.y = 400
	protag = newChar
	boss = newBoss
	add_dakka(newChar)
	add_dakka(newBoss)


var absorbingBoxImitator = preload("res://vfx/vfxAbsorbingBoxImitator.tscn")

func cleanBoss():
	curBossfightStatus = null
	gameSource = null
	protag = null
	boss = null
	if bossHealthbar != null:
		remove_child(bossHealthbar)
		bossHealthbar.queue_free()
	if playerHealthbar != null:
		remove_child(playerHealthbar)
		playerHealthbar.queue_free()
	bossHealthbar = null
	playerHealthbar = null
	showingHealthbars = false
	playerHealth = 3
	for boolet in dakka:
		if is_instance_valid(boolet):
			remove_child(boolet)
			boolet.queue_free()
	dakka.clear()
	big_bossfight = false

func show_health_bars():
	showingHealthbars = true
	curBossfightStatus = BossStatus.SHOW_HEALTHBARS
	var newHealthbar = healthbarScene.instantiate()
	newHealthbar.global_position.x = 900
	newHealthbar.global_position.y = -100
	bossHealthbar = newHealthbar
	add_dakka(bossHealthbar)
	bossHealthbar.z_index = 0
	var secondHealthbar = HBoxContainer.new()
	playerHealthbar = secondHealthbar
	playerHealthbar.add_theme_constant_override("separation", 75)
	for i in playerHealth:
		var heart = TextureRect.new()
		heart.texture = heartImg
		playerHealthbar.add_child(heart)
	playerHealthbar.global_position.x = 200
	playerHealthbar.global_position.y = 1150
	add_dakka(playerHealthbar)
	playerHealthbar.z_index = 0
	for box in boxes:
		if box != gameSource:
			if box.destroyed:
				box.customNum = -3
			else:
				box.get_node("Outline").texture = load("res://boxImgs/outlineClosed.png")
				var new_bullet = absorbingBoxImitator.instantiate()
				new_bullet.load(box)
				new_bullet.position = box.global_position
				(new_bullet as AbsorbingBoxImitator).velocity = (new_bullet as AbsorbingBoxImitator).velocity.rotated(box.global_position.direction_to(protag.position).angle())
				addVfx(new_bullet)
				box.destroyBox()

func postBoss():
	$RestartButton.visible = true
	if won:
		pass
	else:
		remove_child(protag)

func remove_dakka(toRemove):
	dakka.erase(toRemove)
	remove_child(toRemove)
	toRemove.queue_free()

var flyingBoxScene = preload("res://vfx/vfxFlyingBoxImitator.tscn")

func hurtPlayer():
	if big_bossfight and gameRunning and playerHealth > 0 and boss.health > 0:
		$OneshotSoundPlayer.play()
		playerHealth -= 1
		playerHealthbar.remove_child(playerHealthbar.get_children()[playerHealth])
		protag.whenHit()
		if playerHealth == 0:
			lose()
			var flying_thing = flyingBoxScene.instantiate()
			flying_thing.loadFromBox(gameSource)
			flying_thing.global_position = protag.global_position
			addVfx(flying_thing)
			postBoss()
		

func update_boss_healthbar():
	bossHealthbar.updateInfo(boss.health)
