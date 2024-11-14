extends Box

func on_open() -> void:
    var revealAllAdjacent = false
    var newType = main.all_boxes[main.rng.randi_range(0, main.unlockedBoxes - 1)]
    for box in get_adjacent_boxes(false, false):
        if box.id != newType:
            box.loadType(newType)
            if box.revealed:
                revealAllAdjacent = true
    if revealAllAdjacent:
        for box in get_adjacent_boxes(true, false):
            box.revealBox()