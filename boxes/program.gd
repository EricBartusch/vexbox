extends Box

func on_open() -> void:
	set_custom_num(6)

func on_other_box_opened(other):
	set_custom_num(customNum - 1)
	if customNum <= 0:
		hide_custom_num()
