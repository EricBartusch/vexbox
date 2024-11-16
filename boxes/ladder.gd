extends Box

func can_use() -> bool:
	var canGo = true
	for row in main.rows:
		var oneOpen = false
		for box in row:
			if !box.destroyed and box.open:
				if !oneOpen:
					oneOpen = true
				else:
					oneOpen = false
					break
		if !oneOpen:
			canGo = false
			break
	return canGo

func on_self_clicked() -> void:
	main.win()
