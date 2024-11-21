extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "pandoras":
		if main.getBoxStat("pandoras", "timesActivated") >= 100:
			unlock()

func postRevealBox(revealed):
	if enabled:
		var count = 0
		for box in main.boxes:
			if box.revealed and !box.destroyed:
				count += 1
		if count >= 15:
			for box in main.boxes:
				if !box.destroyed and !box.revealed and box.id == "pandoras":
					box.revealBox()

func getProgress():
	return main.getBoxStat("pandoras", "timesActivated")

func getMaxProgress():
	return 100
