extends Box

func on_open() -> void:
	for box in get_adjacent_boxes(true, false):
		box.revealBox()

func on_other_box_opened(other) -> void:
	lg(nameText + " exploded!")
	for box in get_adjacent_boxes(false, false):
		main.destroy_box(box)
	main.destroy_box(self)
