class_name Box extends Control

var id: String
var revealed = false
var just_opened = false
var open = false
var nameText = ""
var tooltipText = ""
var revealedImg
var row = -1
var col = -1
var destroyed = false
var customNum = -1
var origPosX
var origPosY
var was_revealed_when_opened: bool
static var main: Main
static var propery_names := init_properties()

static var imgTable = {
	"winner": preload("res://boxImgs/winner.png"),
	"empty": preload("res://boxImgs/empty.png"),
	"loss": preload("res://boxImgs/loss.png"),
	"revealrandom": preload("res://boxImgs/revealrandom.png"),
	"revealrow": preload("res://boxImgs/revealrow.png"),
	"onegold": preload("res://boxImgs/onegold.png"),
	"poison": preload("res://boxImgs/poison.png"),
	"antidote": preload("res://boxImgs/antidote.png"),
	"exploding": preload("res://boxImgs/exploding.png"),
	"payforreveals": preload("res://boxImgs/payforreveals.png"),
	"star": preload("res://boxImgs/star.png"),
	"shadow": preload("res://boxImgs/shadow.png"),
	"jumpscare": preload("res://boxImgs/jumpscare.png"),
	"safety": preload("res://boxImgs/safety.png"),
	"twogold": preload("res://boxImgs/twogold.png"),
	"fire": preload("res://boxImgs/fire.png"),
	"threegold": preload("res://boxImgs/threegold.png"),
	"spendtowin": preload("res://boxImgs/spendtowin.png"),
	"revealcorners": preload("res://boxImgs/revealcorners.png"),
	"dragon": preload("res://boxImgs/dragon.png"),
	"sword": preload("res://boxImgs/sword.png"),
	"ghost": preload("res://boxImgs/ghost.png"),
	"clock": preload("res://boxImgs/clock.png"),
	"books": preload("res://boxImgs/books.png"),
	"sacrifice": preload("res://boxImgs/sacrifice.png"),
	"poverty": preload("res://boxImgs/poverty.png"),
	"closeadjacent": preload("res://boxImgs/closeadjacent.png"),
	"threed": preload("res://boxImgs/threed.png"),
	"income": preload("res://boxImgs/income.png"),
	"boss": preload("res://boxImgs/boss.png"),
	"shy": preload("res://boxImgs/shy.png"),
	"mimic": preload("res://boxImgs/mimic.png"),
	"curse": preload("res://boxImgs/curse.png"),
	"payforshield": preload("res://boxImgs/payforshield.png"),
	"heart": preload("res://boxImgs/heart.png"),
	"music": preload("res://boxImgs/music.png"),
	"sus": preload("res://boxImgs/sus.png"),
	"speedrun": preload("res://boxImgs/speedrun.png"),
	"demolition": preload("res://boxImgs/demolition.png"),
	"heartbreak": preload("res://boxImgs/heartbreak.png"),
	"rowbomb": preload("res://boxImgs/rowbomb.png"),
	"closenext": preload("res://boxImgs/closenext.png"),
	"autoopen": preload("res://boxImgs/autoopen.png"),
	"rowwin": preload("res://boxImgs/rowwin.png"),
	"teacher": preload("res://boxImgs/teacher.png"),
	"armageddon": preload("res://boxImgs/armageddon.png"),
	"bedrock": preload("res://boxImgs/bedrock.png"),
	"cloak": preload("res://boxImgs/cloak.png"),
	"desert": preload("res://boxImgs/desert.png"),
	"fairy": preload("res://boxImgs/fairy.png"),
	"hat": preload("res://boxImgs/hat.png"),
	"invert": preload("res://boxImgs/invert.png"),
	"selfdestruct": preload("res://boxImgs/selfdestruct.png"),
	"wand": preload("res://boxImgs/wand.png"),
	"instaopen": preload("res://boxImgs/instaopen.png"),
	"blackjack": preload("res://boxImgs/blackjack.png"),
	"egg": preload("res://boxImgs/egg.png"),
	"inferno": preload("res://boxImgs/inferno.png"),
	"key": preload("res://boxImgs/key.png"),
	"lock": preload("res://boxImgs/lock.png"),
	"match": preload("res://boxImgs/match.png"),
	"pandoras": preload("res://boxImgs/pandoras.png"),
	"revival": preload("res://boxImgs/revival.png"),
	"smartbomb": preload("res://boxImgs/smartbomb.png"),
	"territory": preload("res://boxImgs/territory.png"),
	"worldbearer": preload("res://boxImgs/worldbearer.png"),
	"princess": preload("res://boxImgs/princess.png"),
	"mine": preload("res://boxImgs/mine.png"),
	"clone": preload("res://boxImgs/clone.png"),
	"gamer": preload("res://boxImgs/gamer.png"),
	"magnifying": preload("res://boxImgs/magnifying.png"),
	"virus": preload("res://boxImgs/virus.png"),
	"starve": preload("res://boxImgs/starve.png"),
	"spire": preload("res://boxImgs/spire.png"),
	"crumbling": preload("res://boxImgs/crumbling.png"),
	"tripleplay": preload("res://boxImgs/tripleplay.png"),
	"food": preload("res://boxImgs/food.png"),
	"allseeingeye": preload("res://boxImgs/allseeingeye.png"),
	"waterfall": preload("res://boxImgs/waterfall.png"),
	"meteor": preload("res://boxImgs/meteor.png"),
	"daredevil": preload("res://boxImgs/daredevil.png"),
	"paint": preload("res://boxImgs/paint.png"),
	"ice": preload("res://boxImgs/ice.png"),
	"bullseye": preload("res://boxImgs/bullseye.png"),
	"confidential": preload("res://boxImgs/confidential.png"),
	"fishingrod": preload("res://boxImgs/fishingrod.png"),
	"impatient": preload("res://boxImgs/impatient.png"),
	"transmog": preload("res://boxImgs/transmog.png"),
	"stuck": preload("res://boxImgs/stuck.png"),
	"fish": preload("res://boxImgs/fish.png"),
	"dna": preload("res://boxImgs/dna.png"),
	"guardian": preload("res://boxImgs/guardian.png"),
	"painttwo": preload("res://boxImgs/painttwo.png"),
	"moon": preload("res://boxImgs/moon.png"),
	"butterfly": preload("res://boxImgs/butterfly.png"),
	"map": preload("res://boxImgs/map.png"),
	"treasure": preload("res://boxImgs/treasure.png"),
	"checkbox": preload("res://boxImgs/checkbox.png"),
	"stellar": preload("res://boxImgs/stellar.png"),
	"flying": preload("res://boxImgs/flying.png"),
	"underworld": preload("res://boxImgs/underworld.png"),
	"program": preload("res://boxImgs/program.png"),
	"sleepy": preload("res://boxImgs/sleepy.png"),
	"exp": preload("res://boxImgs/exp.png"),
	"ivy": preload("res://boxImgs/ivy.png"),
	"flower": preload("res://boxImgs/flower.png"),
	"finalboss": preload("res://boxImgs/finalboss.png"),
	"compass": preload("res://boxImgs/compass.png"),
	"slots": preload("res://boxImgs/slots.png"),
	"scrap": preload("res://boxImgs/scrap.png"),
	"info": preload("res://boxImgs/info.png"),
	"ladder": preload("res://boxImgs/ladder.png"),
	"portal": preload("res://boxImgs/portal.png"),
	"winter": preload("res://boxImgs/winter.png"),
	"dice": preload("res://boxImgs/dice.png"),
	"darts": preload("res://boxImgs/darts.png"),
	"spike": preload("res://boxImgs/spike.png"),
	"dungeon": preload("res://boxImgs/dungeon.png"),
	"cauldron": preload("res://boxImgs/cauldron.png"),
	"alphabet": preload("res://boxImgs/alphabet.png"),
	"stamp": preload("res://boxImgs/stamp.png"),
	"clumsy": preload("res://boxImgs/clumsy.png"),
	"smiley": preload("res://boxImgs/smiley.png"),
	"crystalball": preload("res://boxImgs/crystalball.png"),
	"badgebox": preload("res://boxImgs/badgebox.png"),
	"candy": preload("res://boxImgs/candy.png"),
	"toolbox": preload("res://boxImgs/toolbox.png"),
	"kettle": preload("res://boxImgs/kettle.png"),
	"cannon": preload("res://boxImgs/cannon.png"),
	"otherworld": preload("res://boxImgs/otherworld.png"),
	"rowgold": preload("res://boxImgs/rowgold.png"),
	"gazer": preload("res://boxImgs/gazer.png"),
	"firework": preload("res://boxImgs/firework.png"),
	"doubleup": preload("res://boxImgs/doubleup.png"),
	"lonely": preload("res://boxImgs/lonely.png"),
	"underrated": preload("res://boxImgs/underrated.png")
}

static var scriptTable = {
	"winner": preload("res://boxes/winner.gd"),
	"empty": preload("res://boxes/empty.gd"),
	"loss": preload("res://boxes/loss.gd"),
	"revealrandom": preload("res://boxes/revealrandom.gd"),
	"revealrow": preload("res://boxes/revealrow.gd"),
	"onegold": preload("res://boxes/onegold.gd"),
	"poison": preload("res://boxes/poison.gd"),
	"antidote": preload("res://boxes/antidote.gd"),
	"exploding": preload("res://boxes/exploding.gd"),
	"payforreveals": preload("res://boxes/payforreveals.gd"),
	"star": preload("res://boxes/star.gd"),
	"shadow": preload("res://boxes/shadow.gd"),
	"jumpscare": preload("res://boxes/jumpscare.gd"),
	"safety": preload("res://boxes/safety.gd"),
	"twogold": preload("res://boxes/twogold.gd"),
	"fire": preload("res://boxes/fire.gd"),
	"threegold": preload("res://boxes/threegold.gd"),
	"spendtowin": preload("res://boxes/spendtowin.gd"),
	"revealcorners": preload("res://boxes/revealcorners.gd"),
	"dragon": preload("res://boxes/dragon.gd"),
	"sword": preload("res://boxes/sword.gd"),
	"ghost": preload("res://boxes/ghost.gd"),
	"clock": preload("res://boxes/clock.gd"),
	"books": preload("res://boxes/books.gd"),
	"sacrifice": preload("res://boxes/sacrifice.gd"),
	"poverty": preload("res://boxes/poverty.gd"),
	"closeadjacent": preload("res://boxes/closeadjacent.gd"),
	"threed": preload("res://boxes/threed.gd"),
	"income": preload("res://boxes/income.gd"),
	"boss": preload("res://boxes/boss.gd"),
	"shy": preload("res://boxes/shy.gd"),
	"mimic": preload("res://boxes/mimic.gd"),
	"curse": preload("res://boxes/curse.gd"),
	"payforshield": preload("res://boxes/payforshield.gd"),
	"heart": preload("res://boxes/heart.gd"),
	"music": preload("res://boxes/music.gd"),
	"sus": preload("res://boxes/sus.gd"),
	"speedrun": preload("res://boxes/speedrun.gd"),
	"demolition": preload("res://boxes/demolition.gd"),
	"heartbreak": preload("res://boxes/heartbreak.gd"),
	"rowbomb": preload("res://boxes/rowbomb.gd"),
	"closenext": preload("res://boxes/closenext.gd"),
	"autoopen": preload("res://boxes/autoopen.gd"),
	"rowwin": preload("res://boxes/rowwin.gd"),
	"teacher": preload("res://boxes/teacher.gd"),
	"armageddon": preload("res://boxes/armageddon.gd"),
	"bedrock": preload("res://boxes/bedrock.gd"),
	"cloak": preload("res://boxes/cloak.gd"),
	"desert": preload("res://boxes/desert.gd"),
	"fairy": preload("res://boxes/fairy.gd"),
	"hat": preload("res://boxes/hat.gd"),
	"invert": preload("res://boxes/invert.gd"),
	"selfdestruct": preload("res://boxes/selfdestruct.gd"),
	"wand": preload("res://boxes/wand.gd"),
	"instaopen": preload("res://boxes/instaopen.gd"),
	"blackjack": preload("res://boxes/blackjack.gd"),
	"egg": preload("res://boxes/egg.gd"),
	"inferno": preload("res://boxes/inferno.gd"),
	"key": preload("res://boxes/key.gd"),
	"lock": preload("res://boxes/lock.gd"),
	"match": preload("res://boxes/match.gd"),
	"pandoras": preload("res://boxes/pandoras.gd"),
	"revival": preload("res://boxes/revival.gd"),
	"smartbomb": preload("res://boxes/smartbomb.gd"),
	"territory": preload("res://boxes/territory.gd"),
	"worldbearer": preload("res://boxes/worldbearer.gd"),
	"princess": preload("res://boxes/princess.gd"),
	"mine": preload("res://boxes/mine.gd"),
	"clone": preload("res://boxes/clone.gd"),
	"gamer": preload("res://boxes/gamer.gd"),
	"magnifying": preload("res://boxes/magnifying.gd"),
	"virus": preload("res://boxes/virus.gd"),
	"starve": preload("res://boxes/starve.gd"),
	"spire": preload("res://boxes/spire.gd"),
	"crumbling": preload("res://boxes/crumbling.gd"),
	"tripleplay": preload("res://boxes/tripleplay.gd"),
	"food": preload("res://boxes/food.gd"),
	"allseeingeye": preload("res://boxes/allseeingeye.gd"),
	"waterfall": preload("res://boxes/waterfall.gd"),
	"meteor": preload("res://boxes/meteor.gd"),
	"daredevil": preload("res://boxes/daredevil.gd"),
	"paint": preload("res://boxes/paint.gd"),
	"ice": preload("res://boxes/ice.gd"),
	"bullseye": preload("res://boxes/bullseye.gd"),
	"confidential": preload("res://boxes/confidential.gd"),
	"fishingrod": preload("res://boxes/fishingrod.gd"),
	"impatient": preload("res://boxes/impatient.gd"),
	"transmog": preload("res://boxes/transmog.gd"),
	"stuck": preload("res://boxes/stuck.gd"),
	"fish": preload("res://boxes/fish.gd"),
	"dna": preload("res://boxes/dna.gd"),
	"guardian": preload("res://boxes/guardian.gd"),
	"painttwo": preload("res://boxes/painttwo.gd"),
	"moon": preload("res://boxes/moon.gd"),
	"butterfly": preload("res://boxes/butterfly.gd"),
	"map": preload("res://boxes/map.gd"),
	"treasure": preload("res://boxes/treasure.gd"),
	"checkbox": preload("res://boxes/checkbox.gd"),
	"stellar": preload("res://boxes/stellar.gd"),
	"flying": preload("res://boxes/flying.gd"),
	"underworld": preload("res://boxes/underworld.gd"),
	"program": preload("res://boxes/program.gd"),
	"sleepy": preload("res://boxes/sleepy.gd"),
	"exp": preload("res://boxes/exp.gd"),
	"ivy": preload("res://boxes/ivy.gd"),
	"flower": preload("res://boxes/flower.gd"),
	"finalboss": preload("res://boxes/finalboss.gd"),
	"compass": preload("res://boxes/compass.gd"),
	"slots": preload("res://boxes/slots.gd"),
	"scrap": preload("res://boxes/scrap.gd"),
	"info": preload("res://boxes/info.gd"),
	"ladder": preload("res://boxes/ladder.gd"),
	"portal": preload("res://boxes/portal.gd"),
	"winter": preload("res://boxes/winter.gd"),
	"dice": preload("res://boxes/dice.gd"),
	"darts": preload("res://boxes/darts.gd"),
	"spike": preload("res://boxes/spike.gd"),
	"dungeon": preload("res://boxes/dungeon.gd"),
	"cauldron": preload("res://boxes/cauldron.gd"),
	"alphabet": preload("res://boxes/alphabet.gd"),
	"stamp": preload("res://boxes/stamp.gd"),
	"clumsy": preload("res://boxes/clumsy.gd"),
	"smiley": preload("res://boxes/smiley.gd"),
	"crystalball": preload("res://boxes/crystalball.gd"),
	"badgebox": preload("res://boxes/badgebox.gd"),
	"candy": preload("res://boxes/candy.gd"),
	"toolbox": preload("res://boxes/toolbox.gd"),
	"kettle": preload("res://boxes/kettle.gd"),
	"cannon": preload("res://boxes/cannon.gd"),
	"otherworld": preload("res://boxes/otherworld.gd"),
	"rowgold": preload("res://boxes/rowgold.gd"),
	"gazer": preload("res://boxes/gazer.gd"),
	"firework": preload("res://boxes/firework.gd"),
	"doubleup": preload("res://boxes/doubleup.gd"),
	"lonely": preload("res://boxes/lonely.gd"),
	"underrated": preload("res://boxes/underrated.gd")
}

static func init_properties() -> Array[String]:
	var control_properties := Control.new().get_property_list()
	var box_properties = Box.new().get_property_list()
	var properties: Array[String] = []
	for i in box_properties:
		var found := false
		for j in control_properties:
			if i.name == j.name:
				found = true
				break
		if found:
			continue
		properties.push_back(i.name)
	return properties

func load_text() -> void:
	var text := load_box_text(id)
	nameText = text[0]
	tooltipText = text[1]

static func load_box_text(type: String) -> Array[String]:
	return [tr_box(type, "name"), tr_box(type, "desc")]

func load_img():
	revealedImg = get_box_img(id)
	show_img()

func show_img():
	if revealed:
		$Sprite2D.texture = revealedImg

static func get_box_img(type: String) -> Texture2D:
	return imgTable[type]

static func get_box_script(classname: String) -> GDScript:
	return scriptTable[classname]
	#return tester
	#return load("res://boxes/" + classname.to_lower() + ".gd")

func tr_local(key: String) -> String:
	return tr_box(id, key)

static func tr_box(type: String, key: String) -> String:
	return main.tr("box." + type + "." + key)

func set_custom_num(val):
	customNum = val
	$Number.visible = true
	$Number.text = str(val)

func hide_custom_num():
	$Number.visible = false
	customNum = -1
	$Number.text = "BUG"

func on_open() -> void:
	pass

func on_other_box_opened(_box: Box) -> void:
	pass

func on_other_box_opened_immediate(_box: Box) -> void:
	pass

func can_use() -> bool:
	return false

func on_self_clicked() -> void:
	pass

func can_destroy() -> bool:
	for box in main.boxes:
		if box.id == "bedrock" and box.open and !box.destroyed:
			return false
	return true

func on_destroy() -> void:
	pass

func on_other_box_destroyed(_box: Box) -> void:
	pass

func on_reveal(_was_already_revealed: bool) -> void:
	pass

func on_other_box_revealed(_box: Box) -> void:
	pass

func on_type_about_to_change(_new_type: String) -> void:
	pass

func on_type_changed(_old_type: String) -> void:
	pass

func on_other_box_type_changed(_other_box: Box) -> void:
	pass

func on_close() -> void:
	pass

func should_hide_custom_num() -> bool:
	return !open

func destroyBox():
	if !can_destroy():
		return
	main.play_sfx(SFXTypes.DESTROY)
	destroyed = true
	visible = false
	hide_custom_num()
	on_destroy()
	for box in main.boxes:
		if box.open and not box.just_opened and not box.destroyed and main.gameRunning:
			box.on_other_box_destroyed(self)

func reviveBox():
	if destroyed:
		destroyed = false
		visible = true
		closeBox()

func loadBox(new_type: String, new_row: int, new_col: int) -> void:
	row = new_row
	col = new_col
	loadType(new_type)

func loadType(new_type: String) -> void:
	if new_type != id:
		if revealed:
			main.play_sfx(SFXTypes.TRANSMOG)
		hide_custom_num()
		var old_type = id
		on_type_about_to_change(new_type)
		id = new_type
		var properties := {}
		for i in propery_names:
			properties[i] = get(i)
		set_script(get_box_script(id))
		set_process(true)
		for i in properties:
			set(i, properties[i])
		load_text()
		load_img()
		just_opened = true
		on_type_changed(old_type)
		if !main.loadingGame:
			for box in main.boxes:
				box.on_other_box_type_changed(self)
			for badge in main.get_node("AchievementsContainer").get_children():
				badge.onBoxTypeChanged(self)

func revealBox():
	if !destroyed:
		var was_already_revealed = revealed
		revealed = true
		$Sprite2D.texture = revealedImg
		if !open:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
		on_reveal(was_already_revealed)
		if !was_already_revealed:
			$Sprite2D.modulate = Color(0.6, 0.6, 0.6, 1)
			main.play_sfx(SFXTypes.REVEAL)
			lg(nameText + " was revealed!")
			for box in main.boxes:
				box.on_other_box_revealed(self)

func openBox():
	if !destroyed and !open:
		main.play_sfx(SFXTypes.OPEN)
		main.modBoxStat(id, "opens", 1)
		was_revealed_when_opened = revealed
		revealed = true
		just_opened = true
		open = true
		$Outline.texture = load("res://boxImgs/outlineClicked.png")
		load_img()
		$Sprite2D.modulate = Color(1, 1, 1, 1)
		lg("Opened " + nameText)
		on_open()
		for box in main.boxes:
			if box != self:
				box.on_other_box_opened_immediate(self)

func closeBox():
	if open:
		$Sprite2D.modulate = Color(0.8, 0.8, 0.8, 1)
		main.play_sfx(SFXTypes.CLOSE)
		lg(nameText + " was closed.")
		open = false
		if should_hide_custom_num():
			hide_custom_num()
		on_close()
		$Outline.texture = load("res://boxImgs/outlineRevealed.png")

func updateTooltipForMe():
	var curName = "Unknown Box"
	var curStatus = "Closed"
	var curDesc = "What could be inside?"
	if revealed:
		if id == "mimic" and get("disguise") != null and revealed and not open:
			id = get("disguise")
			load_text()
			curName = nameText
			curStatus = "Revealed"
			curDesc = tooltipText
			id = "mimic"
			load_text()
		else:
			curName = nameText
			if open:
				curStatus = "Opened"
			else:
				curStatus = "Revealed"
			curDesc = tooltipText
	main.get_node("Tooltip").setup(curName, curStatus, curDesc + addText())
	if revealed:
		main.get_node("Tooltip").setupStats(main.getBoxStat(id, "opens"), main.getBoxStat(id, "wins"))

func addText() -> String:
	return ""

static var cursorTransmog = preload("res://cursorImgs/cursorTransmog.png")
static var cursorDestroy = preload("res://cursorImgs/cursorDestroy.png")
static var cursorClose = preload("res://cursorImgs/cursorClose.png")
static var cursorReveal = preload("res://cursorImgs/cursorReveal.png")
static var cursorUse = preload("res://cursorImgs/cursorUse.png")
static var cursorNo = preload("res://cursorImgs/cursorNo.png")
static var cursorOpen = preload("res://cursorImgs/cursorOpen.png")
static var cursorNormal = preload("res://cursorImgs/cursorNormal.png")
static var cursorPortal = preload("res://cursorImgs/cursorPortal.png")

func updateCursorForMe():
	if !Input.is_action_pressed("pan"):
		var normCursor = true
		if !destroyed:
			if main.has_status(StatusTypes.DEMOLISH):
				normCursor = false
				Input.set_custom_mouse_cursor(cursorDestroy)
			elif main.has_status(StatusTypes.SWAP):
				normCursor = false
				Input.set_custom_mouse_cursor(cursorPortal)
			else:
				if revealed and main.has_status(StatusTypes.TRANSMOG):
					normCursor = false
					Input.set_custom_mouse_cursor(cursorTransmog)
				else:
					if !open:
						if main.has_status(StatusTypes.SAFETY) and !revealed:
							normCursor = false
							Input.set_custom_mouse_cursor(cursorReveal)
					else:
						if main.has_status(StatusTypes.CLOSENEXT) and id != "closenext":
							normCursor = false
							Input.set_custom_mouse_cursor(cursorClose)
						elif can_use():
							normCursor = false
							Input.set_custom_mouse_cursor(cursorUse)
		if normCursor:
			if !destroyed and !open:
				if canOpen():
					Input.set_custom_mouse_cursor(cursorOpen)
				else:
					Input.set_custom_mouse_cursor(cursorNo)
			else:
				Input.set_custom_mouse_cursor(cursorNormal)

func _process(_delta):
	if !main.big_bossfight:
		var mousePos = get_viewport().get_mouse_position()
		if mousePos.x >= global_position.x - 37.5 and mousePos.x <= global_position.x + 37.5 and mousePos.y >= global_position.y - 37.5 and mousePos.y <= global_position.y + 37.5:
			if !destroyed:
				updateTooltipForMe()
			if main.gameRunning:
				updateCursorForMe()

func get_adjacent_boxes(notRevealed, notOpen):
	var result = []
	var myRow = main.rows[row]
	if col != 0:
		result.append(myRow[col - 1])
	if col < myRow.size() - 1:
		result.append(myRow[col+1])
	if row > 0:
		var rowAbove = main.rows[row-1]
		if col != 0:
			result.append(rowAbove[col - 1])
		if rowAbove.size() > col:
			result.append(rowAbove[col])
	if row < main.unlockedRows - 1:
		var rowBelow = main.rows[row+1]
		result.append(rowBelow[col])
		result.append(rowBelow[col + 1])
	var holder = []
	for box in result:
		if !box.destroyed:
			holder.append(box)
	result = holder
	if notRevealed:
		var real = []
		for box in result:
			if !box.revealed:
				real.append(box)
		return real
	else:
		if notOpen:
			var real = []
			for box in result:
				if !box.open:
					real.append(box)
			return real
		else:
			return result

func innerOpen():
	main.last_opened = self
	openBox()
	main.await_postclick()

func get_box_counter(id):
	for box in main.boxes:
		if box.id == id and box.customNum >= 0 and !box.destroyed:
			return box.customNum
	return 0

func box_is_open(id):
	for box in main.boxes:
		if box.id == id and box.open and !box.destroyed:
			return true
	return false

func canOpen():
	if !main.gameRunning or main.loadingGame:
		return false
	var can_open = true
	if box_is_open("territory"):
		can_open = false
		for box in get_adjacent_boxes(false, false):
			if box.open:
				can_open = true
				break
	for box in get_adjacent_boxes(false, false):
		if box.id == "ice" and box.customNum > 0 and !box.destroyed and box.open:
			can_open = false
	if get_box_counter("program") > 0:
		for boxRow in main.rows:
			for other in boxRow:
				if !other.destroyed and !other.open:
					if other.row < row:
						can_open = false
						break
	return can_open

func tryOpen():
	if canOpen():
		innerOpen()

func close_random_other():
	var valids = []
	for box in main.boxes:
		if box.open and box != self and !box.destroyed:
			valids.append(box)
	if valids.size() > 0:
		var toClose = valids.pick_random()
		toClose.closeBox()

func lg(text):
	main.logToLog($Sprite2D.texture, text, id)

func _on_button_pressed() -> void:
	if main.gameRunning && !main.awaiting_post_click and !main.big_bossfight:
		if main.has_status(StatusTypes.DEMOLISH):
			var owned = main
			main.destroy_box(self)
			owned.change_status_amount(StatusTypes.DEMOLISH, -1)
		elif main.has_status(StatusTypes.SWAP):
			var oldPos = global_position
			var oldOriginX = origPosX
			var oldOriginY = origPosY
			var oldRow = row
			var oldCol = col
			var other = main.get_status(StatusTypes.SWAP).stored
			global_position = other.global_position
			origPosX = other.origPosX
			origPosY = other.origPosY
			row = other.row
			col = other.col
			main.rows[other.row][other.col] = self
			other.global_position = oldPos
			other.origPosX = oldOriginX
			other.origPosY = oldOriginY
			other.row = oldRow
			other.col = oldCol
			main.rows[oldRow][oldCol] = other
			main.change_status_amount(StatusTypes.SWAP, -1)
		else:
			if main.has_status(StatusTypes.TRANSMOG) and revealed:
				var valids = []
				for newType in main.all_boxes:
					if newType != id:
						valids.append(newType)
				var typeToAdd = valids.pick_random()
				loadType(typeToAdd)
				main.change_status_amount(StatusTypes.TRANSMOG, -1)
			else:
				if !open:
					if main.has_status(StatusTypes.SAFETY):
						if not revealed:
							revealBox()
							main.change_status_amount(StatusTypes.SAFETY, -1)
						else:
							tryOpen()
					else:
						tryOpen()
				else:
					if main.has_status(StatusTypes.CLOSENEXT) and id != "closenext":
						closeBox()
						main.change_status_amount(StatusTypes.CLOSENEXT, -1)
					else:
						if can_use():
							on_self_clicked()
							main.update_stat_texts()
							for box in main.boxes:
								if box.open:
									box.on_other_box_click_activated(self)
	else:
		if !main.gameRunning:
			main.startGame()

func win():
	main.win()
	if !main.statsMap[id].has("wins"):
		main.statsMap[id]["wins"] = 1
	else:
		main.statsMap[id]["wins"] += 1

func lose():
	main.lose()
	if !main.statsMap[id].has("losses"):
		main.statsMap[id]["losses"] = 1
	else:
		main.statsMap[id]["losses"] += 1

func modStat(statId, val):
	main.modBoxStat(id, statId, val)

func badgeEquipped(id):
	return main.hasBadge(id)

func on_other_box_click_activated(box) -> void:
	pass
