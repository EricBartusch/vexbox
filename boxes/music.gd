extends Box

func on_open() -> void:
	main.get_node("MusicPlayer").play()

func on_close():
	var stopMusic = true
	for box in main.boxes:
		if box != self and box.id == "music" and box.open and !box.destroyed:
			stopMusic = false
	if stopMusic:
		main.get_node("MusicPlayer").stop()

func on_destroy() -> void:
	if open:
		var stopMusic = true
		for box in main.boxes:
			if box != self and box.id == "music" and box.open and !box.destroyed:
				stopMusic = false
		if stopMusic:
			main.get_node("MusicPlayer").stop()

func on_type_about_to_change(_new_type: String) -> void:
	if open:
		var stopMusic = true
		for box in main.boxes:
			if box != self and box.id == "music" and box.open and !box.destroyed:
				stopMusic = false
		if stopMusic:
			main.get_node("MusicPlayer").stop()
