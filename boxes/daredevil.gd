extends Box

func can_use():
	return true

func on_self_clicked() -> void:
	modStat("timesActivated", 1)
	var result = main.rng.randi_range(0, 9)
	main.play_sfx(SFXTypes.ACTIVATE)
	if result <= 1:
		lg("Lucky! Daredevil Box made you win!")
		win()
	elif result <= 4:
		lg("Daredevil Box made you lose!")
		lose()
	else:
		lg("Daredevil Box didn't do anything!")
