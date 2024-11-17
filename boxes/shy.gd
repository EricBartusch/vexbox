extends Box

func on_other_box_opened(other) -> void:
	if main.rng.randi_range(0, 2) == 2:
		modStat("timesActivated", 1)
		closeBox()
