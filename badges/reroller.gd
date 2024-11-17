extends Badge

func onOpenBox(box):
	if !unlocked and box.id == "dna":
		if main.getBoxStat("dna", "opens") >= 25:
			unlock()

func getProgress():
	return main.getBoxStat("dna", "opens")

func getMaxProgress():
	return 25
