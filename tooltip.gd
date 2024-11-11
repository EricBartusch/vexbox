extends Control

var hovered = false
var reInitThisTurn = 0

func setup(name, status, desc):
	hovered = true
	reInitThisTurn = 5
	$Header.text = name
	$Status.text = status
	$Description.text = desc

func _process(delta):
	if hovered:
		hovered = false
	else:
		$Header.text = ""
		$Status.text = ""
		$Description.text = ""
