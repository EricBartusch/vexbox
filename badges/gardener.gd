extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "ivy":
		if main.getBoxStat("ivy", "opens") >= 100:
			unlock()

func getProgress():
	return main.getBoxStat("ivy", "opens")

func getMaxProgress():
	return 100
