extends Box

func on_other_box_opened() -> void:
    if main.rng.randi_range(0, 2) == 2:
        closeBox()