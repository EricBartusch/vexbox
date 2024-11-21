extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "clock":
		if main.getBoxStat("clock", "opens") >= 1:
			unlock()

func getProgress():
	return main.getBoxStat("clock", "opens")

func getMaxProgress():
	return 1

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "clock":
				box.loadType("info")
