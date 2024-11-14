extends Box

func on_open() -> void:
    set_custom_num(9)

func on_other_box_opened() -> void:
    if open and !main.last_opened.was_revealed_when_opened and customNum > 0 and !just_opened:
        set_custom_num(customNum-1)
        if customNum == 0:
            main.win()
            if main.gameRunning:
                hide_custom_num()