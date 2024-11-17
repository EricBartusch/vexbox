extends Badge

func postGameEnd():
	if !unlocked and main.getStat("instantlosses") >= 10:
		unlock()

func onRunStart():
	if enabled:
		for box in main.boxes:
			if box.id == "loss" or box.id == "jumpscare":
				box.loadType("books")

func getProgress():
	return main.getStat("instantlosses")

func getMaxProgress():
	return 10
