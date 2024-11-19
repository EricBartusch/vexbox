extends Box

func on_open():
	for box in get_adjacent_boxes(false, false):
		if box.row < row:
			box.loadType("demolition")
		elif box.row > row:
			box.loadType("closenext")
