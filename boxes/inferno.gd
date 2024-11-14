extends Box

func can_use() -> bool:
    var count = 0
    for box in main.boxes:
        if box.id == "fire" and box.open:
            count += 1
    if count >= 10:
        return true
    return false

func on_self_clicked() -> void:
    var count = 0
    for box in main.boxes:
        if box.id == "fire" and box.open:
            count += 1
    if count >= 10:
        main.play_sfx(SFXTypes.ACTIVATE)
        main.win()