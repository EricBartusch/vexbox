extends Box

func on_open() -> void:
	if customNum == -1:
		set_custom_num(1)
	else:
		set_custom_num(customNum + 1)
		if customNum == 3:
			lg("The elusive THREE-OPEN victory!")
			win()

func should_hide_custom_num() -> bool:
	return false
