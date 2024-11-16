extends Box

func on_open():
	for i in 5:
		var valids = []
		for box in main.boxes:
			if box.id != "ice" and !box.destroyed:
				valids.append(box)
		if valids.size() > 0:
			var toChange = valids.pick_random()
			toChange.loadType("ice")
