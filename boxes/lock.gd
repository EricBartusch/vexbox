extends Box

func on_open() -> void:
	if get_box_counter("key") > 0:
		lg("Key unlocks the Lock Box - VICTORY!")
		win()
