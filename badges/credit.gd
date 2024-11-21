extends Badge

func postUseBoxClick(box):
	if !unlocked and main.getStat("goldSpent") >= 100:
		unlock()

func onRunStart():
	if enabled:
		main.add_status(StatusTypes.GOLD, 3)

func getProgress():
	return main.getStat("goldSpent")

func getMaxProgress():
	return 100
