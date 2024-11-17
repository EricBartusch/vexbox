extends Box

func on_destroy() -> void:
	if open:
		lg("The Egg has hatched!")
		win()
