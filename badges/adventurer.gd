extends Badge

func onRunStart():
	for i in 2:
		var valids = []
		for box in main.boxes:
			if box.id != "fishing":
				valids.append(box)
		valids.pick_random().loadType("fishing")

func getProgress():
	return main.getBoxStat("fish", "wins")

func getMaxProgress():
	return 3
