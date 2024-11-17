extends Box

func on_other_box_opened(box):
	for other in box.get_adjacent_boxes(false, false):
		if !other.destroyed:
			if other.id == "hat" or other.id == "cloak" or other.id == "wand":
				other.revealBox()
				modStat("timesActivated", 1)
