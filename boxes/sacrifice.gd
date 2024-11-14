extends Box

func on_open() -> void:
    set_custom_num(5)

func can_use() -> bool:
    return customNum > 0

func on_self_clicked() -> void:
    if customNum > 0:
        main.play_sfx(SFXTypes.ACTIVATE)
        var thingy = main
        var toChange = thingy.get_random_box()
        main.destroy_box(toChange)
        thingy.reveal_random()
        set_custom_num(customNum - 1)