extends Box

func can_use() -> bool:
	return main.status_amount(StatusTypes.GOLD) >= 2

func on_self_clicked() -> void:
	if main.status_amount(StatusTypes.GOLD) >= 2:
		main.play_sfx(SFXTypes.ACTIVATE)
		main.change_status_amount(StatusTypes.GOLD, -2)
		for i in 4:
			var valids = []
			for box in main.boxes:
				if box.id != "winner" and !box.destroyed and !box.revealed:
					valids.append(box)
			if valids.size() > 0:
				var toChange = valids.pick_random()
				toChange.loadType("winner")
