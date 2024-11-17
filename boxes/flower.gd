extends Box

func on_other_box_type_changed(other):
	if open and !destroyed:
		modStat("timesActivated", 1)
		other.closeBox()
		other.revealBox()
