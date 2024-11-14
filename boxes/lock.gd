extends Box

func on_open() -> void:
    if main.has_status(StatusTypes.KEY):
        main.win()