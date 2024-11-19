extends Box

func on_other_box_opened(other) -> void:
	for box in main.boxes:
		if !box.destroyed:
			modStat("destroys", 1)
			main.destroy_box(box)
			break
