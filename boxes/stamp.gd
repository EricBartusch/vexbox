extends Box

func on_open():
	var dupeBoxes = []
	var ids = []
	for box in main.boxes:
		if !box.destroyed:
			if ids.has(box.id) and !dupeBoxes.has(box.id):
				dupeBoxes.append(box.id)
			elif !ids.has(box.id):
				ids.append(box.id)
	for box in main.boxes:
		if !box.destroyed:
			if dupeBoxes.has(box.id):
				box.revealBox()
				modStat("timesActivated", 1)
