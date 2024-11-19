extends Badge

func postDestroyBox(box):
	if !unlocked and main.getBoxStat("crumbling", "destroys") >= 200:
		unlock()

func getProgress():
	return main.getBoxStat("crumbling", "destroys")

func getMaxProgress():
	return 200
