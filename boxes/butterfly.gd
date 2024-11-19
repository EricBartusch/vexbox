extends Box

func on_type_about_to_change(_new_type: String) -> void:
	if open:
		lg("The Butterfly has evolved!")
		win()
