extends Box

func on_open() -> void:
    var willDie = false
    for box in main.boxes:
        if box.id == "dragon" and box.revealed and not box.destroyed:
            willDie = true
    if willDie:
        main.lose()
    else:
        main.add_status(StatusTypes.GOLD, 3)