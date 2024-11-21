extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "invert":
		if main.getBoxStat("invert", "opens") >= 5:
			unlock()

func getProgress():
	return main.getBoxStat("invert", "opens")

func getMaxProgress():
	return 5

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "invert":
				box.loadType("confidential")
