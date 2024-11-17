extends Box

func on_open() -> void:
	main.add_status(StatusTypes.SAFETY, 1)
