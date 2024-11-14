extends Box

func on_open() -> void:
    var hasWand = false
    var hasHat = false
    for box in main.boxes:
        if box.id == "wand" and !box.destroyed and box.open:
            hasWand = true
        if box.id == "hat" and !box.destroyed and box.open:
            hasHat = true
    if hasWand and hasHat:
        main.win()