extends Box

func on_open() -> void:
	var willDie = false
	for box in main.boxes:
		if box.id == "dragon" and box.revealed and not box.destroyed:
			willDie = true
	if willDie:
		lg("Princess sees the dragon - you lose!")
		lose()
	else:
		main.add_status(StatusTypes.GOLD, 3)
