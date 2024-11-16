extends Box

func can_destroy() -> bool:
	return !open and !main.big_bossfight
