extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "sleepy":
		if main.getBoxStat("sleepy", "opens") >= 5:
			unlock()

func getProgress():
	return main.getBoxStat("sleepy", "opens")

func getMaxProgress():
	return 5

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "sleepy":
				box.revealBox()
