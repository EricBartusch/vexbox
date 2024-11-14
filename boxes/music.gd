extends Box

func on_open() -> void:
    main.get_node("MusicPlayer").play()