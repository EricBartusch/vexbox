extends Box

func on_open() -> void:
    if main.has_status(StatusTypes.INVERSION):
        main.remove_status(StatusTypes.INVERSION)
    else:
        main.add_status(StatusTypes.INVERSION, 1)