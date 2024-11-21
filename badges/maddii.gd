extends Badge

func postUseBoxClick(box):
	if box.id == "sacrifice" and !unlocked:
		if main.getBoxStat("sacrifice", "timesActivated") >= 66:
			unlock()

func getProgress():
	return main.getBoxStat("sacrifice", "timesActivated")

func getMaxProgress():
	return 66
