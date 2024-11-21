extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "stellar":
		if main.getBoxStat("stellar", "opens") >= 25:
			unlock()

func getProgress():
	return main.getBoxStat("stellar", "opens")

func getMaxProgress():
	return 25

func onRunStart():
	if enabled:
		for box in main.boxes:
			if !box.destroyed and !box.revealed:
				box.revealBox()
				break
