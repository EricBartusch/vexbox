extends Box

func on_open():
	main.add_status(StatusTypes.SWAP, 1)
	for status in main.get_node("StatusList").get_children():
		if status.type == StatusTypes.SWAP:
			status.stored = self
