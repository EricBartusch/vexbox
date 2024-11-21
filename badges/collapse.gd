extends Badge

func postDestroyBox(box):
	if !unlocked and main.getStat("destroys") >= 500:
		unlock()

func getProgress():
	return main.getStat("destroys")

func getMaxProgress():
	return 500
