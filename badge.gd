class_name Badge extends Control

@export var id : String
var unlocked = false
var enabled = false

var hoverName = ""
var hoverDesc = ""
var unlockText = ""

static var main: Main
static var propery_names := init_properties()

func _ready():
	loadImg()
	loadText()
	refreshOutline()

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
	$Sprite2D.texture = get_badge_img(id)

static func get_badge_img(type: String) -> Texture2D:
	return load("res://badgeImgs/"+type+".png")

func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	if mousePos.x >= global_position.x - 37.5 and mousePos.x <= global_position.x + 37.5 and mousePos.y >= global_position.y - 37.5 and mousePos.y <= global_position.y + 37.5:
		updateTooltipForMe()

func updateTooltipForMe():
	main.get_node("Tooltip").setup(hoverName, unlockText, hoverDesc)

func unlock():
	unlocked = true
	refreshOutline()
		
func refreshOutline():
	if unlocked:
		if enabled:
			$Outline.texture = load("res://boxImgs/outlineClicked.png")
		else:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
	else:
		$Outline.texture = load("res://boxImgs/outlineClosed.png")

func _on_button_button_up() -> void:
	if unlocked:
		if enabled:
			enabled = false
			refreshOutline()
		else:
			enabled = true
			refreshOutline()
			for badge in get_parent().get_children():
				if badge != self:
					badge.enabled = false
					badge.refreshOutline()

func onRunStart() -> void:
	pass

func postGameEnd() -> void:
	pass
