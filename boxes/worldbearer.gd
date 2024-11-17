extends Box

func on_destroy() -> void:
	if open:
		lg("The Worldbearer has fallen!")
		lose()
