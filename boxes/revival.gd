extends Box

func on_open() -> void:
    var valids = []
    for box in main.boxes:
        if box.destroyed:
            valids.append(box)
    var siz = valids.size()
    for i in min(5, siz):
        var toRes = valids.pick_random()
        toRes.reviveBox()
        valids.erase(toRes)