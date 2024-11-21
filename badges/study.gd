extends Badge

func onRunStart():
	if enabled:
		setup_number(6)

func onOpenBox(box):
	if !unlocked and main.getStat("opens") >= 500:
		unlock()
	if enabled:
		setup_number(number-1)
		if number == 0:
			qLog("Study is activating!")
			setup_number(6)
			main.reveal_random()

func getProgress():
	return main.getStat("opens")

func getMaxProgress():
	return 500

func getCost():
	return 2
