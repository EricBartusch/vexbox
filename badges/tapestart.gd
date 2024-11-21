extends Badge

func postGameEnd():
	if !unlocked and main.getBoxStat("tripleplay", "wins") >= 1:
		unlock()

func getProgress():
	return main.getBoxStat("tripleplay", "wins")

func getMaxProgress():
	return 1

func onRunStart():
	if enabled:
		setup_number(6)

func getCost():
	return 2

func onOpenBox(box):
	if enabled:
		setup_number(number-1)
		if number == 0:
			qLog("Closer is activating!")
			setup_number(6)
			var valids = []
			for other in main.boxes:
				if other.open and !other.destroyed:
					valids.append(other)
			valids.pick_random().closeBox()
