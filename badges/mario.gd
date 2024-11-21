extends Badge

static var ids = ["flower", "guardian", "onegold", "twogold", "threegold"]

func postGameEnd():
	if !unlocked and main.losses >= 250:
		unlock()

func onOpenBox(box):
	if enabled:
		if box.row > 0:
			var result = []
			var rowAbove = main.rows[box.row-1]
			if box.col != 0:
				result.append(rowAbove[box.col - 1])
			if rowAbove.size() > box.col:
				result.append(rowAbove[box.col])
			if result.size() > 0:
				for other in result:
					if !other.revealed and !other.destroyed and ids.has(other.id):
						qLog("Plumber Badge activates!")
						other.revealBox()

func getProgress():
	return main.losses

func getMaxProgress():
	return 250

func getCost():
	return 3
