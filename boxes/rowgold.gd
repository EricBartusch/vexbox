extends Box

func on_open():
	var goldAmt = 0
	for box in main.rows[row]:
		if box != self and box.open:
			goldAmt += 1
	if goldAmt > 0:
		main.add_status(StatusTypes.GOLD, goldAmt)
