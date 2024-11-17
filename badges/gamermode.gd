extends Badge

func postGameEnd():
	if main.bestWinstreak >= 10:
		unlock()

func onRunStart():
	for i in min(5, main.winstreak):
		var valids = []
		for box in main.boxes:
			if box.id != "gamer":
				valids.append(box)
		var toChange = valids.pick_random()
		toChange.loadType("gamer")

func getProgress():
	return main.bestWinstreak

func getMaxProgress():
	return 10
