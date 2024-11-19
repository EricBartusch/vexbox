extends Box

func on_open() -> void:
	if main.opens == 0:
		win()
