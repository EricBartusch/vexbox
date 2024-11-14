extends Control

var ID

func load(newTexture, newText, boxID):
	$TextureRect.texture = newTexture
	$Label.text = newText
	ID = boxID

func updateTooltipForMe():
	var name = get_parent().get_parent().get_parent().tr("box." + ID + ".name")
	var desc = get_parent().get_parent().get_parent().tr("box." + ID + ".desc")
	get_parent().get_parent().get_parent().get_node("Tooltip").setup(name, "", desc)

func _process(delta: float) -> void:
	if ID != null:
		var mousePos = get_viewport().get_mouse_position()
		if mousePos.x >= global_position.x and mousePos.x <= global_position.x + 300 and mousePos.y >= global_position.y and mousePos.y <= global_position.y + 30:
			updateTooltipForMe()
