extends Badge

func postGameEnd():
	if !unlocked and main.getBoxStat("tripleplay", "wins") >= 1:
		unlock()

func getProgress():
	return main.getBoxStat("tripleplay", "wins")

func getMaxProgress():
	return 1

func onRunStart():
	if enabled:
		main.add_status(StatusTypes.CLOSENEXT, 1)
