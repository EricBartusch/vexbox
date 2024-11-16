extends Badge

func postGameEnd():
	if !unlocked and main.wins >= 5:
		unlock()

func onRunStart():
	main.reveal_random()
