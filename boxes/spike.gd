extends Box

func on_open() -> void:
	var count = 0
	for box in main.boxes:
		if box.open and !box.destroyed and box.id == "spike":
			count += 1
	if count >= 3:
		lg("Slain by spikes!")
		lose()
