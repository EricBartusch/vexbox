extends Box

func on_open() -> void:
    var count = 0
    for box in main.boxes:
        if box.open and !box.destroyed:
            count += 1
    if count >= 11:
        main.win()