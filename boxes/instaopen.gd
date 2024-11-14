extends Box

func on_open() -> void:
    var myRow = main.rows[row]
    if col != 0:
        myRow[col-1].openBox()
    if col < myRow.size() - 1:
        myRow[col+1].openBox()