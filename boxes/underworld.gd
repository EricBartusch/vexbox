extends Box

func on_open() -> void:
    main.lose()
    if main.gameRunning:
        main.win()