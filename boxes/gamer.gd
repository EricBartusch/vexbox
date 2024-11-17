extends Box

func on_open() -> void:
	if main.winstreak > 0:
		win()
