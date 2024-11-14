extends Box

func can_use() -> bool:
    return main.status_amount(StatusTypes.GOLD) >= 1

func on_self_clicked() -> void:
    if main.status_amount(StatusTypes.GOLD) >= 1:
        var valids = []
        for box in main.boxes:
            if !box.destroyed and box.open:
                valids.append(box)
        if valids.size() > 0:
            main.play_sfx(SFXTypes.ACTIVATE)
            main.change_status_amount(StatusTypes.GOLD, -1)
            var toClose = valids.pick_random()
            toClose.closeBox()