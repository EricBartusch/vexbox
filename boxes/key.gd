extends Box

func on_open() -> void:
	set_custom_num(1)


func on_other_box_opened(other):
	if customNum > 0:
		set_custom_num(customNum - 1)
