extends Box

func on_open() -> void:
	lose()
	if main.gameRunning:
		win()
