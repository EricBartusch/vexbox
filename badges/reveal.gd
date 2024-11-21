extends Badge

func postGameEnd():
	if !unlocked and main.wins >= 5:
		unlock()

func onRunStart():
	if enabled:
		main.reveal_random()

func getProgress():
	return main.wins

func getMaxProgress():
	return 5

func getCost():
	return 1
