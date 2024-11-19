extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "badgebox":
		if main.getBoxStat("badgebox", "opens") >= 50:
			unlock()

func getProgress():
	return main.getBoxStat("badgebox", "opens")

func getMaxProgress():
	return 50
