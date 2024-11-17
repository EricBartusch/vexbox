extends Box

func on_open() -> void:
	var list = []
	for box in main.boxes:
		if box.id != "fire" and !box.destroyed:
			list.append(box)
	var toChange = list.pick_random()
	toChange.loadType("fire")
