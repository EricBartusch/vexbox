extends Box

func on_open() -> void:
	for box in get_adjacent_boxes(false, false):
		if box.id == "bedrock" and box.open:
			win()
