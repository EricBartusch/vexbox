extends Box

func on_open() -> void:
    if row > 0:
        var result = []
        var rowAbove = main.rows[row-1]
        if col != 0:
            result.append(rowAbove[col - 1])
        if rowAbove.size() > col:
            result.append(rowAbove[col])
        for box in result:
            if !box.destroyed:
                box.loadType("ivy")