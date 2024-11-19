extends Box

func on_open():
	set_custom_num(3)

func on_other_box_opened(box):
	for other in get_adjacent_boxes(false, false):
		if other == box:
			set_custom_num(customNum-1)
			if customNum == 0:
				for i in 5:
					main.reveal_random()
				hide_custom_num()
