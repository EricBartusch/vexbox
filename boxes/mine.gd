extends Box

func on_other_box_opened() -> void:
    for box in get_adjacent_boxes(false, false):
        if main.last_opened == box:
            lg("Mined some gold!")
            main.add_status(StatusTypes.GOLD, 1)