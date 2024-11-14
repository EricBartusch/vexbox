extends Box

func on_open() -> void:
    if row == main.unlockedRows - 1:
        main.win()
    else:
        var valids = []
        for box in main.rows[row+1]:
            if !box.destroyed:
                valids.append(box)
        if valids.size() > 0:
            var toChange = valids.pick_random()
            toChange.loadType("waterfall")