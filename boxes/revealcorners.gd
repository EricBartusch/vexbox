extends Box

func on_open() -> void:
	var revealedAny = false
	var topRow = 0
	for row in main.rows:
		var validRow = false
		for box in row:
			if !box.destroyed:
				validRow = true
				break
		if validRow:
			break
		topRow += 1
	for box in main.rows[topRow]:
		revealedAny = true
		box.revealBox()
		modStat("timesActivated", 1)
	var bottomrow = main.unlockedRows - 1
	var made_change = true
	while made_change:
		var valid_corner = false
		for box in main.rows[bottomrow]:
			if !box.destroyed:
				valid_corner = true
		if !valid_corner:
			made_change = true
			bottomrow -= 1
		else:
			made_change = false
	var last = -1
	var didFirst = false
	for box in main.rows[bottomrow]:
		if !box.destroyed:
			if !didFirst:
				revealedAny = true
				box.revealBox()
				modStat("timesActivated", 1)
				didFirst = true
			last = box.col
	if last != -1:
		revealedAny = true
		main.rows[bottomrow][last].revealBox()
		modStat("timesActivated", 1)
	if !revealedAny and badgeEquipped("trigazeimprove"):
		win()
