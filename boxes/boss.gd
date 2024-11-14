extends Box

func on_open() -> void:
    set_custom_num(12)

func on_other_box_opened() -> void:
    if customNum > 0:
        if customNum == 1:
            lg("You slayed the Boss!")
            main.win()
        set_custom_num(customNum-1)
        if main.gameRunning and customNum == 0:
                hide_custom_num()