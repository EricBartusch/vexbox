extends Box

func on_open() -> void:
	if (main.has_status(StatusTypes.GOLD)):
		main.remove_status(StatusTypes.GOLD)
