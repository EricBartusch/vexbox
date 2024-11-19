extends Box

func on_open():
	var toReveal
	var lowest = 99999
	for box in main.boxes:
		if !box.destroyed and !box.revealed and main.getBoxStat(box.id, "opens") < lowest:
			toReveal = box
			lowest = main.getBoxStat(box.id, "opens")
	if toReveal != null:
		toReveal.revealBox()
