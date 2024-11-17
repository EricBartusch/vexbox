class_name Badge extends Control

@export var id : String
var seen = false
var unlocked = false
var enabled = false

var hoverName = ""
var hoverDesc = ""
var unlockText = ""
var revealedImg
var cursorOpen = load("res://cursorImgs/cursorOpen.png")
var cursorNormal = load("res://cursorImgs/cursorNormal.png")

static var main: Main
static var propery_names := init_properties()

var number = -1

func setup_number(newNumber):
	number = newNumber
	$Number.visible = true
	$Number.text = str(number)

func hide_number():
	number = -1
	$Number.visible = false

func _ready():
	var properties := {}
	for i in propery_names:
		properties[i] = get(i)
	set_script(get_badge_script(id))
	set_process(true)
	for i in properties:
		set(i, properties[i])
	loadImg()
	loadText()
	refreshStatus()
	refreshOutline()

func get_adjacent_badges():
	var adjacents = []
	var badges = get_parent().get_children()
	var location = badges.find(self)
	# top
	if location > 7:
		adjacents.append(badges[location-8])
	#left
	if location % 8 != 0:
		adjacents.append(badges[location-1])
	#right
	if location % 7 != 0:
		adjacents.append(badges[location+1])
	#down
	if badges.size() > location+7:
		adjacents.append(badges[location+7])
	return adjacents

func refreshStatus():
	if !seen:
		for badge in get_adjacent_badges():
			if badge.unlocked:
				seen = true
				$Sprite2D.texture = revealedImg

static func init_properties() -> Array[String]:
	var control_properties := Control.new().get_property_list()
	var box_properties = Badge.new().get_property_list()
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

func loadText() -> void:
	var text := load_badge_text(id)
	hoverName = text[0]
	hoverDesc = text[1]
	unlockText = text[2]

static func load_badge_text(type: String) -> Array[String]:
	return [tr_badge(type, "name"), tr_badge(type, "desc"), tr_badge(type, "unlock")]

func tr_local(key: String) -> String:
	return tr_badge(id, key)

static func tr_badge(type: String, key: String) -> String:
	return main.tr("badge." + type + "." + key)

func loadImg():
	revealedImg = get_badge_img(id)
	if seen:
		$Sprite2D.texture = revealedImg

static func get_badge_script(classname: String) -> GDScript:
	return load("res://badges/" + classname.to_lower() + ".gd")

static func get_badge_img(type: String) -> Texture2D:
	return load("res://badgeImgs/"+type+".png")

func _process(delta):
	if !main.big_bossfight:
		var mousePos = get_viewport().get_mouse_position()
		if mousePos.x >= global_position.x - 37.5 and mousePos.x <= global_position.x + 37.5 and mousePos.y >= global_position.y - 37.5 and mousePos.y <= global_position.y + 37.5:
			updateTooltipForMe()
			if !main.gameRunning:
				if unlocked and (main.badgePoints - main.bpInUse >= getCost() or enabled):
					Input.set_custom_mouse_cursor(cursorOpen)
				else:
					Input.set_custom_mouse_cursor(cursorNormal)

func updateTooltipForMe():
	if seen or unlocked:
		main.get_node("Tooltip").setup(hoverName, unlockText, "???" if !showDescWhenRevealed() else hoverDesc)
		var progress = getProgress()
		var maxProgress = getMaxProgress()
		main.get_node("Tooltip").setupProgressBar(progress, maxProgress, getCost())
	else:
		main.get_node("Tooltip").setup("Unknown Achievement", "", "Unlock an adjacent achievement to see this one!")

func unlock():
	unlocked = true
	if !main.unlockedBadges.has(id):
		main.unlockedBadges.append(id)
	$Sprite2D.texture = revealedImg
	refreshOutline()
	for badge in get_parent().get_children():
		badge.refreshStatus()
		
func refreshOutline():
	if unlocked:
		if enabled:
			$Outline.texture = load("res://boxImgs/outlineClicked.png")
		else:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
	else:
		$Outline.texture = load("res://boxImgs/outlineClosed.png")

func _on_button_button_up() -> void:
	if !main.gameRunning:
		if unlocked:
			if enabled:
				enabled = false
				main.equippedBadges.erase(id)
				main.bpInUse -= getCost()
				refreshOutline()
				main.updateBadgePoints()
				main.save()
			else:
				if main.badgePoints - main.bpInUse >= getCost():
					enabled = true
					main.equippedBadges.append(id)
					main.bpInUse += getCost()
					refreshOutline()
					main.updateBadgePoints()
					main.save()

func getCost() -> int:
	return 1

func onRunStart() -> void:
	pass

func postGameEnd() -> void:
	pass

func onOpenBox(box) -> void:
	pass

func getProgress() -> int:
	return -1
	
func getMaxProgress() -> int:
	return -1

func showDescWhenRevealed() -> bool:
	return true

func onBoxTypeChanged(box):
	pass

func qLog(text):
	main.logToLog($Sprite2D.texture, text, null)
