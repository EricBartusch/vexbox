extends Box

func on_other_box_opened(box):
	if box.id != "spike":
		for i in 2:
			var valids = []
			for other in box.get_adjacent_boxes(false, true):
				if other.id != "spike":
					valids.append(other)
			if valids.size() > 0:
				valids.pick_random().loadType("spike")
