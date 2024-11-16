extends Box

static var arrowImg = preload("res://uiImgs/arrow.png")
var arrows = []

func on_open() -> void:
	for box in main.boxes:
		if box.id == "winner" and !box.destroyed:
			var newArrow = TextureRect.new();
			newArrow.texture = arrowImg
			newArrow.rotation = global_position.direction_to(box.position).angle()
			add_child(newArrow)
			arrows.append(newArrow)

func on_close() -> void:
	for tex in arrows:
		remove_child(tex)
	arrows.clear()
