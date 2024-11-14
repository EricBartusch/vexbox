extends Box

func on_open() -> void:
    for i in 3:
        var list = []
        for box in main.boxes:
            if box.id != "fish" and !box.destroyed and !box.revealed:
                list.append(box)
        if list.size() > 0:
            var toChange = list.pick_random()
            toChange.loadType("fish")