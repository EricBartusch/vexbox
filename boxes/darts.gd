extends Box

func can_use() -> bool:
	var total = 0
	for box in main.boxes:
		if box.customNum > 0 and !box.destroyed:
			total += box.customNum
	return total >= 20

func on_self_clicked() -> void:
	win()
