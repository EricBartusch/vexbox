extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "sleepy":
		if main.getBoxStat("sleepy", "opens") >= 10:
			unlock()

func getProgress():
	return main.getBoxStat("sleepy", "opens")

func getMaxProgress():
	return 10

func onRunStart():
	if enabled:
		for box in main.boxes:
			if !box.destroyed and (box.id == "winner" || box.id == "loss"):
				box.destroyBox()
			elif !box.destroyed and box.id == "sleepy":
				box.loadType("clone")
