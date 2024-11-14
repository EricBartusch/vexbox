extends Box

func on_open() -> void:
    var adjacents = get_adjacent_boxes(false, false)
    var winning = true
    for box in adjacents:
        if !box.open:
            winning = false
    if winning:
        main.win()