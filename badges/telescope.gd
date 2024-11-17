extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "stellar":
		if main.getBoxStat("stellar", "opens") >= 20:
			unlock()

func getProgress():
	return main.getBoxStat("stellar", "opens")

func getMaxProgress():
	return 20

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "stellar":
				box.revealBox()
