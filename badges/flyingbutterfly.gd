extends Badge


func postGameEnd():
	if !unlocked and main.getBoxStat("butterfly", "wins") >= 10:
		unlock()

func getProgress():
	return main.getBoxStat("butterfly", "wins")

func getMaxProgress():
	return 10
