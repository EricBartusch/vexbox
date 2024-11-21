extends Badge

func postGameEnd():
	if !unlocked and main.wins >= 50:
		unlock()

func onRunStart():
	if enabled:
		setup_number(3)

func getProgress():
	return main.wins

func getMaxProgress():
	return 50

func onOpenBox(box):
	if enabled and number > 0:
		setup_number(number-1)
		if number == 0:
			for other in main.boxes:
				if other.open and !other.destroyed:
					other.closeBox()
			hide_number()
