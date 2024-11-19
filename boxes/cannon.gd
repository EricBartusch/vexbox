extends Box

func can_use():
	for box in main.rows[row]:
		if box.col > col and !box.destroyed:
			return true
	return false

func on_self_clicked() -> void:
	for box in main.rows[row]:
		if box.col > col and !box.destroyed:
			box.destroyBox()
			break
