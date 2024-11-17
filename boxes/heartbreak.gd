extends Box

func on_other_box_opened(box) -> void:
	if main.rng.randi_range(0, 9) == 9:
		lg(nameText + " activated - oh no!")
		lose()
