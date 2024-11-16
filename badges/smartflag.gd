extends Badge

func postGameEnd():
	if !unlocked and main.statsMap["winner"]["wins"] >= 15:
		unlock()

func onOpenBox(box):
	for other in box.get_adjacent_boxes(true, false):
		if other.id == "winner" and !other.revealed:
			other.revealBox()
