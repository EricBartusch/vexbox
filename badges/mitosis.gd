extends Badge

func onOpenBox(box):
	if enabled and main.opens == 1:
		var myRow = main.rows[box.row]
		if box.col != 0:
			myRow[box.col-1].loadType(box.id)
			myRow[box.col-1].revealBox()
		if box.col < myRow.size() - 1:
			myRow[box.col+1].loadType(box.id)
			myRow[box.col+1].revealBox()

func postGameEnd():
	if !unlocked and main.wins >= 250:
		unlock()

func getProgress():
	return main.wins

func getMaxProgress():
	return 250

func getCost():
	return 2
