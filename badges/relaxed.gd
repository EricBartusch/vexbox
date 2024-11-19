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
	for box in main.boxes:
		if box.type == "clock":
			box.loadType("info")
