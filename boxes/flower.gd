extends Box

func on_other_box_type_changed(other):
	other.closeBox()
	other.revealBox()
