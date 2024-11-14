extends Box

func on_other_box_revealed(box: Box) -> void:
    if !destroyed and open and !box.open:
        main.logToLog(null, "Impatient Box opens the revealed box!")
        box.openBox()