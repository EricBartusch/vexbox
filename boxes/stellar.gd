extends Box

var starScene = preload("res://vfx/vfxStar.tscn")

func on_other_box_opened_immediate(box: Box) -> void:
    if open:
        for i in 3:
            var newStar = starScene.instantiate()
            newStar.global_position.x = box.global_position.x
            newStar.global_position.y = box.global_position.y
            main.addVfx(newStar)