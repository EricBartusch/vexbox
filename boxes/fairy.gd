extends Box

func on_open() -> void:
	var valids = []
	for box in main.boxes:
		if !box.destroyed and !box.revealed and box.id != "fairy":
			valids.append(box)
	if valids.size() > 0:
		var toChange = valids.pick_random()
		toChange.loadType("fairy")
	var count = 0
	for box in main.boxes:
		if box.open and !box.destroyed and box.id == "fairy":
			count += 1
	if count >= 4:
		lg("Four or more fairies - you win!")
		win()
