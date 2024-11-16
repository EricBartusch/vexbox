extends Box

func on_open():
	for box in main.boxes:
		if box.customNum > 0:
			box.set_custom_num(box.customNum+1)
