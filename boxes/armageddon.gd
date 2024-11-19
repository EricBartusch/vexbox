extends Box

func on_open() -> void:
	set_custom_num(3)
	lg("3 opens to Armageddon!")

func on_other_box_opened(box) -> void:
	if customNum == 1:
		lg("Armageddon has arrived!")
		main.modBoxStat(id, "timesActivated", 1)
		main.clear_central()
		main.destroy_box(self)
	elif customNum > 0:
		set_custom_num(customNum - 1)
		lg(str(customNum) + " opens to Armageddon!")
