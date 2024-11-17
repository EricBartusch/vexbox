extends Box

func can_use() -> bool:
	var canGo = true
	for row in main.rows:
		var oneOpen = false
		var anyBox = true
		for box in row:
			if !box.destroyed:
				anyBox = true
				if box.open:
					if !oneOpen:
						oneOpen = true
					else:
						oneOpen = false
						break
		if !oneOpen or !anyBox:
			canGo = false
			break
	return canGo

func on_self_clicked() -> void:
	main.play_sfx(SFXTypes.ACTIVATE)
	win()
