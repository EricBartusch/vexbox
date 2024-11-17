extends Badge

func onBoxTypeChanged(box):
	if box.id == "virus" and !unlocked:
		if main.getBoxStat("virus", "timesActivated") >= 250:
			unlock()
	if box.id == "virus" and enabled:
		var count = 0
		for other in main.boxes:
			if other.id == "virus" and other.open and !other.destroyed:
				count += 1
		if count >= 25:
			qLog("25 or more Viral Boxes - Contagion Badge activates!")
			main.win()

func getProgress():
	return main.getBoxStat("virus", "timesActivated")

func getMaxProgress():
	return 250
