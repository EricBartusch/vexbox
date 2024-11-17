extends Box

static var arrowImg = preload("res://uiImgs/arrow.png")
var arrows = []

func on_open() -> void:
	for box in main.boxes:
		if box.id == "winner" and !box.destroyed:
			var newArrow = TextureRect.new();
			newArrow.texture = arrowImg
			newArrow.size = Vector2(44, 44)
			newArrow.pivot_offset = Vector2(22, 22)
			newArrow.anchor_left = 0.5
			newArrow.anchor_right = 0.5
			newArrow.anchor_top = 0.5
			newArrow.anchor_bottom = 0.5
			newArrow.offset_left = -22
			newArrow.offset_right = -22
			newArrow.offset_top = -22
			newArrow.offset_bottom = -22
			add_child(newArrow)
			newArrow.rotation = global_position.direction_to(box.position).angle()
			arrows.append(newArrow)

func on_close() -> void:
	for tex in arrows:
		remove_child(tex)
	arrows.clear()

func on_type_about_to_change(_new_type: String) -> void:
	for tex in arrows:
		remove_child(tex)
	arrows.clear()
