class_name Main extends Control

var boxScene = preload("res://Box.tscn")
var statusScene = preload("res://StatusEffect.tscn")
var logEntryScene = preload("res://LogEntry.tscn")

var PYRAMID_START_X = 800
var PYRAMID_START_Y = 50

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
var losses = 0
var winstreak = 0
var bestWinstreak = 0
var rng = RandomNumberGenerator.new()
var resetTimer = 0
var last_opened: Box
var pan_x = 0
var pan_y = 0

var PAN_MIN_X = -500
var PAN_MIN_Y = -700
var PAN_MAX_X = 500
var PAN_MAX_Y = 400

var statsMap = {}
var unlockedBadges = []
var equippedBadges = []
var boxesHolderOrigPosX = 400
var boxesHolderOrigPosY = 50
var boxesScale : float = 1

func _init() -> void:
	Box.main = self
	Badge.main = self

func setupStatsMap():
	for box in all_boxes:
		statsMap[box] = {"opens": 0, "wins": 0, "losses": 0, "destroys": 0, "timesActivated": 0, "timesDestroyed": 0}

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
		"statsMap": statsMap,
		"unlockedBadges": unlockedBadges,
		"equippedBadges": equippedBadges,
		"losses": losses
	}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	return(json_string)

func load_save():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var line = save_file.get_line()
	var json = JSON.new()
	
	var parse_result = json.parse(line)
	
	var data = json.data
	for key in data.keys():
			set(key, data[key])
	unlockedRows = 17
	unlockedBoxes = (unlockedRows * (unlockedRows + 1)) / 2
	$NumWinsText.text = ": " + str(wins)
	$WinstreakText.text = "Winstreak: " + str(winstreak)
	$BestWinstreakText.text = "Best Winstreak: " + str(bestWinstreak)
	$WinsToNextText.text = "Reach " + str(winsToNext) + " wins for a NEW ROW." 

func _ready():
	#for id in all_boxes:
		#print("\"" + id + "\": preload(\"res://boxes/" + id + ".gd\"),")
	load_save()
	for badge in $AchievementsContainer.get_children():
		if unlockedBadges.has(badge.id):
			badge.unlock()
			badge.refreshOutline()
		if equippedBadges.has(badge.id):
			badge.enabled = true
			bpInUse += badge.getCost()
			updateBadgePoints()
			badge.refreshOutline()
	startGame()

var loadingGame = false

func get_unlocked_boxes():
	var valids = []
	for i in unlockedBoxes:
		valids.append(all_boxes[i])
	return valids

func startGame():
	#var start = Time.get_ticks_usec()
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
		$BoxesHolder.remove_child(node)
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
	boxesScale = float(1050) / (unlockedRows * float(75))
	if boxesScale > 1:
		boxesScale = 1
	$BoxesHolder.scale.x = boxesScale
	$BoxesHolder.scale.y = boxesScale
	var modAmt = 75 * boxesScale
	while not list.is_empty():
		var instance = boxScene.instantiate()
		var toAdd = list.pop_front()
		#if row == 0:
			#toAdd = "monster"
		#else:
			#toAdd = "empty"
		instance.loadBox(toAdd, row, column)
		$BoxesHolder.add_child(instance)
		boxes.append(instance)
		curRow.append(instance)
		(instance as Control).global_position = Vector2(PYRAMID_START_X - ((column * modAmt)) + (modAmt/2 * row-1), PYRAMID_START_Y + (row * modAmt))
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
	for badge in $AchievementsContainer.get_children():
		badge.onRunStart()
	$AchievementsFront.modulate.a = 0
	update_stat_texts()
	#var end = Time.get_ticks_usec()
	#var worker_time = (end-start)/1000000.0	
	#print(worker_time)

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
		if box.open and not box.just_opened and not box.destroyed and gameRunning and box != last_opened:
			box.on_other_box_opened(last_opened)
	for box in boxes:
		box.just_opened = false
	for box in boxes:
		if box.id == "virus" and box.open:
			box.special = 0
	for badge in $AchievementsContainer.get_children():
		badge.onOpenBox(last_opened)

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
	if opens == 1:
		$AchievementsFront.modulate.a = 0.5
	modStat("opens", 1)
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
	update_revealed_text()

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

func update_revealed_text():
	var revealed = 0
	for box in boxes:
		if box.revealed and not box.destroyed:
			revealed += 1
	$CurRevealedText.text = "Currently Revealed: " + str(revealed)

func after_game_over():
	for badge in $AchievementsContainer.get_children():
		badge.postGameEnd()
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
	$AchievementsFront.modulate.a = 0
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
	after_game_over()

func reset_winstreak():
	winstreak = 0
	$WinstreakText.text = "Winstreak: " + str(winstreak)

func internal_loss():
	$LossFXPlayer.play()
	lost = true
	$ColorRect.color = Color(0.33, 0.2, 0.2, 1)
	qLog("You lost!")
	losses += 1
	gameRunning = false
	$AchievementsFront.modulate.a = 0
	$GameStatusText.text = "You lost."
	if opens == 1:
		modStat("instantlosses", 1)
	reset_winstreak()
	after_game_over()

func win():
	if gameRunning:
		if hasCurse():
			qLog("Curse prevented your victory.")
			for box in boxes:
				if box.id == "curse" and !box.destroyed and box.open:
					box.destroyBox()
					break
		else:
			if has_status(StatusTypes.INVERSION):
				qLog("You win - but it's inverted to a loss!")
				internal_loss()
			else:
				internal_win()

func hasHeart():
	for box in boxes:
		if box.id == "heart" and box.customNum > 0 and !box.destroyed:
			return true
	return false

func hasCurse():
	for box in boxes:
		if box.id == "curse" and !box.destroyed and box.open:
			return true
	return false

func lose():
	if gameRunning:
		if !hasHeart():
			var willDie = true
			for box in boxes:
				if box.id == "guardian" and !box.destroyed and box.open:
					willDie = false
					box.destroyBox()
					break
			if $AchievementsContainer/StartHeart.number > 0 and $AchievementsContainer/StartHeart.enabled:
				qLog("You can't lose thanks to Start Heart!")
				return
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
	if gameRunning:
		var newLogEntry = logEntryScene.instantiate()
		newLogEntry.load(sourceImg, sourceText, ID)
		var prevEntries = $ScrollContainer/LogContainer.get_children()
		$ScrollContainer/LogContainer.add_child(newLogEntry)
		$ScrollContainer.itemAdded = true

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
						modBoxStat("armageddon", "destroys", 1)

func resetGame():
	if resetTimer <= 0:
		resetTimer = 0.1
		reset_winstreak()
		startGame()

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
	$Tooltip.z_index = 0
	$OneshotSoundPlayer.stream = startCombatSound
	$OneshotSoundPlayer.play()
	$RestartButton.visible = false
	$GameStatusText.global_position.y = 236
	$GameStatusSubtext.global_position.y = 306
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
	$Tooltip.z_index = 1
	$GameStatusSubtext.text = "Click any box to restart."
	$GameStatusText.global_position.y = 12
	$GameStatusSubtext.global_position.y = 75
	curBossfightStatus = null
	gameSource = null
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
		if is_instance_valid(boolet) and !boolet.is_queued_for_deletion():
			boolet.queue_free()
	protag = null
	boss = null
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
	toRemove.queue_free()

var flyingBoxScene = preload("res://vfx/vfxFlyingBoxImitator.tscn")

func hurtPlayer():
	if big_bossfight and gameRunning and playerHealth > 0 and boss.health > 0:
		$OneshotSoundPlayer.play()
		playerHealth -= 1
		playerHealthbar.remove_child(playerHealthbar.get_children()[playerHealth])
		protag.whenHit()
		if playerHealth == 0:
			$GameStatusSubtext.text = "Better luck next time. Use the restart button!"
			internal_loss()
			modBoxStat("finalboss", "losses", 1)
			var flying_thing = flyingBoxScene.instantiate()
			flying_thing.loadFromBox(gameSource)
			flying_thing.global_position = protag.global_position
			addVfx(flying_thing)
			postBoss()
		
func get_status(type):
	for other in $StatusList.get_children():
		if other.type == type:
			return other
	return null

func update_boss_healthbar():
	bossHealthbar.updateInfo(boss.health)

func getStat(id):
	if statsMap.has(id):
		return statsMap[id]
	else:
		statsMap[id] = 0
		return 0

func setStat(id, val):
	statsMap[id] = val

func modStat(id, val):
	if statsMap.has(id):
		statsMap[id] += val
	else:
		statsMap[id] = val

func initBoxStats(boxid):
	statsMap[boxid] = {"opens": 0, "wins": 0, "losses": 0, "timesActivated": 0}
	pass

func getBoxStat(boxid, id):
	if statsMap.has(boxid):
		var boxStats = statsMap[boxid]
		if boxStats.has(id):
			return boxStats[id]
		else:
			boxStats[id] = 0
			return 0
	else:
		initBoxStats(boxid)
		statsMap[boxid][id] = 0
		return statsMap[boxid][id]

func setBoxStat(boxid, id, val):
	if statsMap.has(boxid):
		var boxStats = statsMap[boxid]
		if boxStats.has(id):
			statsMap[boxid][id] = val
		else:
			statsMap[boxid][id] = val
	else:
		initBoxStats(boxid)
		statsMap[boxid][id] = val

func modBoxStat(boxid, id, val):
	if statsMap.has(boxid):
		var boxStats = statsMap[boxid]
		if boxStats.has(id):
			statsMap[boxid][id] += val
		else:
			statsMap[boxid][id] = val
	else:
		initBoxStats(boxid)
		statsMap[boxid][id] = val

var badgePoints = 1
var bpInUse = 0
var bpImg = load("res://uiImgs/orb.png")
var usedBpImg = load("res://uiImgs/usedOrb.png")

func updateBadgePoints():
	var children = $BPContainer.get_children()
	for i in badgePoints:
		children[i].visible = true
		if i < bpInUse:
			children[i].texture = usedBpImg
		else:
			children[i].texture = bpImg

func hasBadge(id):
	for badge in $AchievementsContainer.get_children():
		if badge.id == id:
			if badge.enabled:
				return true
			return false
	return false

func _on_options_button_pressed() -> void:
	$OptionsMenu.show_options()
