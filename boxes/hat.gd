extends Box

func on_open() -> void:
    var hasWand = false
    var hasCloak = false
    for box in main.boxes:
        if box.id == "wand" and !box.destroyed and box.open:
            hasWand = true
        if box.id == "cloak" and !box.destroyed and box.open:
            hasCloak = true
    if hasWand and hasCloak:
        main.win()