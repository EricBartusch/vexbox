extends Badge

func postGameEnd():
	if !unlocked and main.getBoxStat("winner", "wins") >= 50:
		unlock()

func onOpenBox(box):
	if enabled:
		for other in box.get_adjacent_boxes(true, false):
			if other.id == "winner" and !other.revealed:
				other.revealBox()

func getProgress():
	return main.getBoxStat("winner", "wins")

func getMaxProgress():
	return 50

func getCost():
	return 2
