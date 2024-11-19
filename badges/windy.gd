extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "flying":
		if main.getBoxStat("flying", "opens") >= 20:
			unlock()

func getProgress():
	return main.getBoxStat("flying", "opens")

func getMaxProgress():
	return 20

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "flying":
				box.revealBox()
