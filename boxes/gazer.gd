extends Box

func on_open():
	set_custom_num(2)

func on_other_box_opened(box):
	for other in get_adjacent_boxes(false, false):
		if other == box:
			set_custom_num(customNum-1)
			if customNum == 0:
				lg("The Gazer sees your actions!")
				lose()
				if main.gameRunning:
					hide_custom_num()
