extends Box

func on_open() -> void:
    for i in 5:
        var list = []
        for box in main.boxes:
            if box.id != "food" and !box.destroyed and !box.revealed:
                list.append(box)
        if list.size() > 0:
            var toChange = list.pick_random()
            toChange.loadType("food")
    set_custom_num(6)

func on_other_box_opened() -> void:
    if customNum > 0:
        if main.last_opened.id == "food":
            set_custom_num(6)
            just_opened = true
        else:
            if customNum == 1:
                lg("The Hungry Box starves!")
                main.lose()
            set_custom_num(customNum - 1)
            if main.gameRunning and customNum == 0:
                hide_custom_num()