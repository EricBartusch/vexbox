extends Box

func on_other_box_opened(box: Box, box_was_revealed: bool) -> void:
    if !box_was_revealed and open and !destroyed and !just_opened:
        main.reveal_random()