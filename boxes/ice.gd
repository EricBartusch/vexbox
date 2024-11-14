extends Box

func on_open() -> void:
    set_custom_num(3)

func on_other_box_opened() -> void:
    if customNum > 0:
        if customNum == 1:
            lg("Ice Box has thawed!")
        set_custom_num(customNum - 1)
        if customNum == 0:
                hide_custom_num()