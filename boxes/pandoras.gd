extends Box

func on_open() -> void:
	for box in main.boxes:
		if box != self and box.revealed and not box.destroyed:
			modStat("timesActivated", 1)
			box.loadType("loss")
