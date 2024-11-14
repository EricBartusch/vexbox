extends Box

func on_reveal(_was_already_revealed: bool) -> void:
    if special == null:
        var replacement = id
        while replacement == id:
            replacement = main.all_boxes[main.rng.randi_range(0, main.unlockedBoxes - 1)]
            special = replacement
    var orig_type := id
    id = special
    load_img()
    load_text()
    $Sprite2D.texture = revealedImg
    id = orig_type