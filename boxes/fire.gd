extends Box

func on_open() -> void:
    var toChange = get_adjacent_boxes(false, true)
    var result = []
    for box in toChange:
        if box.id != id:
            result.append(box)
    if result.size() > 0:
        var toHit = result.pick_random()
        toHit.loadType(id)