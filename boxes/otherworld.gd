extends Box

func can_use():
	return true

func on_self_clicked() -> void:
	destroyBox()
	for box in main.boxes:
		if !box.destroyed and box.revealed:
			var valids = []
			for i in main.all_boxes:
				if i != box.id and i != "max":
					valids.append(i)
			if valids.size() > 0:
				box.loadType(valids.pick_random())
