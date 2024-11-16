extends Badge

func postGameEnd():
	if !unlocked and main.statsMap["opens"] >= 500:
		unlock()

func onRunStart():
	setup_number(5)

func onOpenBox(box):
	setup_number(number-1)
	if number == 0:
		setup_number(5)
		main.reveal_random()
