extends Box

func on_open() -> void:
	set_custom_num(3)

func on_other_box_opened(box) -> void:
	if customNum > 0:
		if customNum == 1:
			var found = main.all_boxes[main.rng.randi_range(0, main.unlockedBoxes - 1)]
			loadType(found)
			closeBox()
		else:
			set_custom_num(customNum - 1)
