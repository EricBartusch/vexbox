extends Badge

func postGameEnd():
	if main.bestWinstreak >= 5:
		unlock()

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "heart":
				box.revealBox()

func getProgress():
	return main.bestWinstreak

func getMaxProgress():
	return 5

func getCost():
	return 2
