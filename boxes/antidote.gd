extends Box

func on_open() -> void:
    if (main.has_status(StatusTypes.POISON)):
        main.remove_status(StatusTypes.POISON)
    for box in get_adjacent_boxes(false, false):
        if box.open and box.id == "virus":
            main.win()