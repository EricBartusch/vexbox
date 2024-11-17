extends Box

func on_open() -> void:
	for box in main.boxes:
		if !box.destroyed and (box.id == "winner" || box.id == "loss"):
			modStat("destroys", 1)
			box.destroyBox()
