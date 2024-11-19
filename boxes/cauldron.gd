extends Box

func on_open():
	for box in main.boxes:
		if box.customNum >= 0 and box.get_node("Number").visible:
			box.set_custom_num(box.customNum+1)
			modStat("timesActivated", 1)
