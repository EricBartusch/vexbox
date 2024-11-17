extends Box

func on_open():
	if badgeEquipped("badgeboxup1"):
		for box in get_adjacent_boxes(true, false):
			box.revealBox()
	if badgeEquipped("badgeboxup2"):
		for box in get_adjacent_boxes(false, false):
			if box.open:
				box.closeBox()
	if badgeEquipped("badgeboxup3"):
		for i in 3:
			var valids = []
			for box in main.boxes:
				if !box.open and box.id != "badgebox":
					valids.append(box)
			if valids.size() > 0:
				valids.pick_random().loadType("badgebox")
