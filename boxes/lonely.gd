extends Box

func on_open():
	if get_adjacent_boxes(false, false).size() < 6:
		lg("Lonely Box isn't surrounded!")
		lose()
