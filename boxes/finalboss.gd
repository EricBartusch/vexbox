extends Box



func on_open():
	if main.rng.randi_range(0, 19) == 0:
		destroyBox()
		main.start_big_bossfight(self)
