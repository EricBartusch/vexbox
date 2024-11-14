extends Box

func on_open() -> void:
    for i in 2:
        var list = []
        for box in main.boxes:
            if box.id != "mimic" and !box.destroyed:
                list.append(box)
        var toChange = list.pick_random()
        var oldType = toChange.id
        toChange.loadType("mimic")
        toChange.disguise = oldType
        if toChange.revealed and not toChange.open:
            toChange.revealBox()