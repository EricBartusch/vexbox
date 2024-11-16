extends Badge

func postGameEnd():
	if !unlocked and main.statsMap["instantLosses"] >= 10:
		unlock()

func onRunStart():
	for box in main.boxes:
		if box.id == "loss" or box.id == "jumpscare":
			box.loadType("books")
