extends Badge

func postDestroyBox(box):
	if !unlocked and main.getStat("destroys") >= 500:
		unlock()

func getProgress():
	return main.getStat("destroys")

func getMaxProgress():
	return 500

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "demolition":
				box.revealBox()

func getCost():
	return 2
