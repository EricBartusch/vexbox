extends Box

func on_open() -> void:
    for i in 2:
        var valids = []
        for box in main.boxes:
            if !box.destroyed and box != self:
                valids.append(box)
        var toChange = valids.pick_random()
        toChange.loadType("loss")