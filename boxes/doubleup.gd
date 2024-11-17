extends Box

func can_use():
	var ids = []
	for box in get_adjacent_boxes(false, false):
		if !box.destroyed:
			if ids.has(box.id):
				return true
			else:
				ids.append(box.id)
	return false

func on_self_clicked() -> void:
	lg("There are two identical boxes next to the Two Box! Nice!")
	win()
