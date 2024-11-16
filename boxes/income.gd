extends Box

func on_other_box_opened(box) -> void:
	if main.rng.randi_range(1, 3) == 1:
		lg(nameText + " generated 1 Gold!")
		main.add_status(StatusTypes.GOLD, 1)
