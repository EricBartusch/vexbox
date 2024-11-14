extends Box

func on_open() -> void:
    var hasHat = false
    var hasCloak = false
    for box in main.boxes:
        if box.id == "hat" and !box.destroyed and box.open:
            hasHat = true
        if box.id == "cloak" and !box.destroyed and box.open:
            hasCloak = true
    if hasHat and hasCloak:
        main.win()