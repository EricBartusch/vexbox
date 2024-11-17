extends Badge

func postGameEnd():
	if !unlocked and main.getBoxStat("finalboss", "wins") >= 1:
		unlock()


func onOpenBox(opened):
	if enabled and (opened.id == "boss" or opened.id == "finalboss"):
		if opened.id == "boss":
			for box in main.boxes:
				if box.id == "finalboss" and !box.revealed and !box.destroyed:
					box.revealBox()
		else:
			for box in main.boxes:
				if box.id == "boss" and !box.revealed and !box.destroyed:
					box.revealBox()

func showDescWhenRevealed():
	return false

func getProgress():
	return main.getBoxStat("finalboss", "wins")

func getMaxProgress():
	return 1
