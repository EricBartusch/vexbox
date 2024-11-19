extends Box

func on_open():
	for i in 2:
		var toChange = get_adjacent_boxes(true, true)
		if toChange.size() > 0:
			toChange.pick_random().revealBox()
