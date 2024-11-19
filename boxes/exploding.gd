extends Box

func on_other_box_opened(other) -> void:
	lg(nameText + " exploded!")
	for box in get_adjacent_boxes(false, false):
		main.destroy_box(box)
		modStat("destroys", 1)
	main.destroy_box(self)
