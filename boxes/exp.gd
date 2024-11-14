extends Box

func on_other_box_opened(_box: Box, box_was_revealed: bool) -> void:
    if !box_was_revealed and open and customNum > 0 and !just_opened:
        set_custom_num(customNum-1)
        if customNum == 0:
            main.win()
            if main.gameRunning:
                hide_custom_num()