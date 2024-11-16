extends Box

func on_other_box_opened(other) -> void:
	# better later
	var willWin = true
	for box in main.boxes:
		if box.canClick():
			willWin = false
	if willWin:
		lg("You've softlocked! Softlock Box activates!")
		main.win()
