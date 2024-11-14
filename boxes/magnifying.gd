extends Box

func can_use() -> bool:
    return main.status_amount(StatusTypes.GOLD) >= 1

func on_self_clicked() -> void:
    if main.status_amount(StatusTypes.GOLD) >= 1:
        main.play_sfx(SFXTypes.ACTIVATE)
        main.change_status_amount(StatusTypes.GOLD, -1)
        main.reveal_random()