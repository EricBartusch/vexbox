extends Box

func on_other_box_click_activated(box) -> void:
	main.reveal_random()
	modStat("timesActivated", 1)
