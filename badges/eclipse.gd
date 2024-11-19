extends Badge

func postGameEnd():
	if !unlocked and main.wins >= 50:
		unlock()

func onRunStart():
	if enabled:
		main.add_status(StatusTypes.ECLIPSE, 3)

func getProgress():
	return main.wins

func getMaxProgress():
	return 50
