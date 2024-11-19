extends Box

func on_other_box_opened(box):
	var valids = []
	for other in box.get_adjacent_boxes(false, false):
		valids.append(other)
	if valids.size() > 0:
		valids.pick_random().destroyBox()
		modStat("destroys", 1)
