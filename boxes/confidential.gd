extends Box

func on_open() -> void:
    var count = 0
    for box in main.boxes:
        if box.revealed and not box.destroyed:
            count += 1
    if count >= 18:
        lg("Espionage victory!")
        main.win()