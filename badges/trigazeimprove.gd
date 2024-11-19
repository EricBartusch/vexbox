extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "revealcorners":
		if main.getBoxStat("revealcorners", "timesActivated") >= 30:
			unlock()

func getProgress():
	return main.getBoxStat("revealcorners", "timesActivated")

func getMaxProgress():
	return 30
