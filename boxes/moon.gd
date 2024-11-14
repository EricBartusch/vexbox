extends Box

func on_self_clicked() -> void:
    for i in 5:
        var valids = []
        for box in main.boxes:
            if !box.destroyed and box.open and box != self:
                valids.append(box)
        if valids.size() > 0:
            main.play_sfx(SFXTypes.ACTIVATE)
            var toClose = valids.pick_random()
            toClose.closeBox()
    destroyBox()