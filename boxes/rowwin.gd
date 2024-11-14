extends Box

func on_open() -> void:
    var willWin = true
    for box in main.rows[row]:
        if !box.open and !box.destroyed:
            willWin = false
    if willWin:
        main.win()