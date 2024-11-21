extends Badge

func postGameEnd():
	if main.bestWinstreak >= 5:
		unlock()

func onRunStart():
	if enabled:
		setup_number(3)

func getProgress():
	return main.bestWinstreak

func getMaxProgress():
	return 5

func getCost():
	return 2

func onOpenBox(box):
	if enabled and number > 0:
		setup_number(number-1)
