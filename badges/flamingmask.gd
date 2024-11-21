extends Badge

func postGameEnd():
	if !unlocked and main.getBoxStat("inferno", "wins") >= 3:
		unlock()

func getProgress():
	return main.getBoxStat("inferno", "wins")

func getMaxProgress():
	return 3
