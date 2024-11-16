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
	return load("res://boxImgs/"+type+".png")

static func get_box_script(classname: String) -> GDScript:
	return load("res://boxes/" + classname.to_lower() + ".gd")

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
		on_other_box_destroyed(self)

func reviveBox():
	if destroyed:
		destroyed = false
		visible = true
		closeBox()

func load(new_type: String, new_row: int, new_col: int) -> void:
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
		on_type_changed(old_type)
		if !main.loadingGame:
			for box in main.boxes:
				box.on_other_box_type_changed(self)

func revealBox():
	if !destroyed:
		var was_already_revealed = revealed
		revealed = true
		$Sprite2D.texture = revealedImg
		if !open:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
		on_reveal(was_already_revealed)
		if !was_already_revealed:
			$Sprite2D.modulate = Color(0.66, 0.66, 0.66, 1)
			main.play_sfx(SFXTypes.REVEAL)
			lg(nameText + " was revealed!")
			for box in main.boxes:
				box.on_other_box_revealed(self)

func openBox():
	if !destroyed and !open:
		main.play_sfx(SFXTypes.OPEN)
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
	main.get_node("Tooltip").setup(curName, curStatus, curDesc)

var cursorTransmog = load("res://cursorImgs/cursorTransmog.png")
var cursorDestroy = load("res://cursorImgs/cursorDestroy.png")
var cursorClose = load("res://cursorImgs/cursorClose.png")
var cursorReveal = load("res://cursorImgs/cursorReveal.png")
var cursorUse = load("res://cursorImgs/cursorUse.png")
var cursorNo = load("res://cursorImgs/cursorNo.png")
var cursorOpen = load("res://cursorImgs/cursorOpen.png")
var cursorNormal = load("res://cursorImgs/cursorNormal.png")

func updateCursorForMe():
	if !Input.is_action_pressed("pan"):
		var normCursor = true
		if !destroyed:
			if main.has_status(StatusTypes.DEMOLISH):
				normCursor = false
				Input.set_custom_mouse_cursor(cursorDestroy)
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

func canOpen():
	var can_open = true
	if main.has_status(StatusTypes.TERRITORY):
		can_open = false
		for box in get_adjacent_boxes(false, false):
			if box.open:
				can_open = true
				break
	for box in get_adjacent_boxes(false, false):
		if box.id == "ice" and box.customNum > 0 and !box.destroyed and box.open:
			can_open = false
	for box in main.boxes:
		if box.id == "program" and box.open and !box.destroyed:
			for boxRow in main.rows:
				for other in boxRow:
					if !other.destroyed and !other.open:
						if other.row < row:
							can_open = false
							break
	return can_open

func canClick():
	if main.has_status(StatusTypes.DEMOLISH):
		return true
	if main.has_status(StatusTypes.DEMOLISH) and revealed:
		return true
	if open:
		if main.has_status(StatusTypes.CLOSENEXT) and id != "closenext":
			return true
	return canOpen() or can_use()

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
						on_self_clicked()
						main.update_stat_texts()
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
