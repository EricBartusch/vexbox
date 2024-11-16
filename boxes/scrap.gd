extends Box

func on_open():
	set_custom_num(0)

func on_other_box_destroyed(_box):
	if customNum <= 0:
		set_custom_num(1)
	else:
		set_custom_num(customNum+1)

func can_use() -> bool:
	return customNum > 0

func on_self_clicked() -> void:
	main.reveal_random()
	set_custom_num(customNum-1)
