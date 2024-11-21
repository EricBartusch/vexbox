extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "badgebox":
		if main.getBoxStat("badgebox", "opens") >= 15:
			unlock()

func getProgress():
	return main.getBoxStat("badgebox", "opens")

func getMaxProgress():
	return 15
