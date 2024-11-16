extends Box

func on_other_box_opened(other) -> void:
	for box in main.boxes:
		if !box.destroyed:
			main.destroy_box(box)
			break
