extends Box

func on_other_box_opened(box) -> void:
	lg(nameText + " exploded!")
	main.destroy_box(self)
