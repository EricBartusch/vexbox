extends Box

func on_open() -> void:
	set_custom_num(8)

func on_other_box_opened(other):
	if customNum > 0:
		set_custom_num(customNum - 1)
		if customNum <= 0:
			lg("You succumb to poison!")
			lose()
			if main.gameRunning:
				hide_custom_num()
