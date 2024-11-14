extends Box

var starScene = preload("res://vfx/vfxStar.tscn")

func on_other_box_opened(box: Box, _box_was_revealed: bool) -> void:
    for i in 3:
        var newStar = starScene.instantiate()
        newStar.global_position.x = box.global_position.x
        newStar.global_position.y = box.global_position.y
        main.addVfx(newStar)