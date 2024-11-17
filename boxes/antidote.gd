extends Box

func on_open() -> void:
	for box in main.boxes:
		if box.id == "poison" and (box.open or box.revealed):
			box.destroyBox()
			main.modBoxStat(id, "destroys", 1)
	for box in get_adjacent_boxes(false, false):
		if box.open and box.id == "virus":
			win()
