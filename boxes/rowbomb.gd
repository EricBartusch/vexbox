extends Box

func on_other_box_opened(other) -> void:
	lg(nameText + " exploded!")
	for box in main.rows[row]:
		if box != self and !box.destroyed:
			modStat("destroys", 1)
			main.destroy_box(box)
	modStat("destroys", 1)
	main.destroy_box(self)
