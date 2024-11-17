extends Box

func on_open() -> void:
	set_custom_num(3)

func on_other_box_opened(box):
	if customNum > 0:
		set_custom_num(customNum-1)
