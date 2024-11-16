extends Box

func on_other_box_opened(other) -> void:
	lg(nameText + " exploded!")
	for box in main.rows[row]:
		if box != self:
			main.destroy_box(box)
	main.destroy_box(self)
