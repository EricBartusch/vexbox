extends Box

func on_open() -> void:
	for box in main.boxes:
		if box.id == "treasure" && !box.destroyed:
			box.revealBox()
