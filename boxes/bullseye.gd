extends Box

func on_open() -> void:
    var will_reveal = true
    for box in get_adjacent_boxes(false, false):
        if box.revealed:
            will_reveal = false
            break
    if will_reveal:
        for box in get_adjacent_boxes(true, true):
            box.revealBox()