extends Box

func on_other_box_revealed(box: Box) -> void:
	if !destroyed and open and !box.open:
		main.logToLog(revealedImg, "Impatient Box opens the revealed box!", "impatient")
		box.openBox()
