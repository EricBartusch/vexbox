extends Box

func on_open() -> void:
	set_custom_num(3)

func on_other_box_opened(other) -> void:
	if customNum > 0:
		if customNum == 1:
			lg("Ice Box has thawed!")
		set_custom_num(customNum - 1)
