extends Box

func on_open() -> void:
	var winning = false
	for box in main.boxes:
		if box.id == "sword" and box.open and !box.destroyed:
			winning = true
	if winning:
		lg("The Dragon has been slain!")
		win()
	else:
		lg("The Dragon slays you!")
		lose()
