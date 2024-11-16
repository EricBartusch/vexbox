extends Badge

func postGameEnd():
	if !unlocked and main.wins >= 50:
		unlock()

func onRunStart():
	main.add_status(StatusTypes.ECLIPSE, 3)
