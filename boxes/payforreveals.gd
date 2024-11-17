extends Box

func can_use() -> bool:
	var valids = get_adjacent_boxes(true, false)
	return valids.size() > 0 and main.status_amount(StatusTypes.GOLD) > 0
	
func on_self_clicked() -> void:
	var valids = get_adjacent_boxes(true, false)
	if valids.size() > 0:
		if main.status_amount(StatusTypes.GOLD) > 0:
			modStat("timesActivated", 1)
			main.play_sfx(SFXTypes.ACTIVATE)
			main.change_status_amount(StatusTypes.GOLD, -1)
			var toReveal = valids.pick_random()
			toReveal.revealBox()
