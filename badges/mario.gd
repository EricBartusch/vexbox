extends Badge

func postGameEnd():
	if !unlocked and main.losses >= 250:
		unlock()

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "guardian":
				box.revealBox()

func getProgress():
	return main.losses

func getMaxProgress():
	return 250

func getCost():
	return 3
