extends Badge

func onBoxTypeChanged(box):
	if !unlocked and main.getStat("transforms") >= 500:
		unlock()

func getProgress():
	return main.getStat("transforms")

func getMaxProgress():
	return 500

func getCost():
	return 2

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "transmog":
				box.revealBox()
