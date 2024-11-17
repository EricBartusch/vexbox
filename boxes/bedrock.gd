extends Box

func can_destroy() -> bool:
	return !open or main.big_bossfight
