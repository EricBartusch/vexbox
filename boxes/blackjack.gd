extends Box

func on_open() -> void:
    var count = 0
    for box in main.boxes:
        if !box.destroyed and box.open:
            count += 1
    if count == 21:
        main.win()
    elif count > 21:
        main.lose()