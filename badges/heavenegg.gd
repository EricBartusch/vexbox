extends Badge

func postGameEnd():
	if !unlocked and main.getBoxStat("egg", "wins") >= 10:
		unlock()

func getProgress():
	return main.getBoxStat("egg", "wins")

func getMaxProgress():
	return 10
