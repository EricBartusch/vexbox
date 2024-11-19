extends Box

func on_open():
	if main.rng.randi_range(0, 19) == 0:
		modStat("timesActivated", 1)
		destroyBox()
		lg("WHAT IS HAPPENING???")
		lg("WASD TO... MOVE?")
		lg("MOUSE TO... WHAT IS EVEN GOING ON!!??")
		main.start_big_bossfight(self)
