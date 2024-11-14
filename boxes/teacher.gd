extends Box

func on_other_box_opened() -> void:
    var valids = get_adjacent_boxes(true, false)
    if valids.size() > 0:
        lg(nameText + " activated!")
        var toReveal = valids.pick_random()
        toReveal.revealBox()