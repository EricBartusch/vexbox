extends Control

@export var type: BadgeTypes.BadgeType

var unlocked = false
var enabled = false
var hoverName = ""
var hoverDesc = ""
var unlockText = ""

func _ready():
	loadImg()
	loadText()
	refreshOutline()

func loadImg():
	match (type):
		BadgeTypes.BadgeType.REVEAL_2_RANDOM:
			$Sprite2D.texture = load("res://badgeImgs/badgeReveal2.png")
		BadgeTypes.BadgeType.LOSSES_TO_WINS:
			$Sprite2D.texture = load("res://badgeImgs/badgeLossToWin.png")
		BadgeTypes.BadgeType.ECLIPSE:
			$Sprite2D.texture = load("res://badgeImgs/badgeCloseAll.png")
		BadgeTypes.BadgeType.SHRUNKEN:
			$Sprite2D.texture = load("res://badgeImgs/badgeShrunk.png")

func loadText():
	match (type):
		BadgeTypes.BadgeType.REVEAL_2_RANDOM:
			hoverName = "Random Reveal 2"
			hoverDesc = "Start the run with a random box revealed."
			unlockText = "To Unlock: Win 5 times."
		BadgeTypes.BadgeType.LOSSES_TO_WINS:
			hoverName = "Bright Future"
			hoverDesc = "Replace the Jumpscare and Loser boxes with Book Boxes."
			unlockText = "To Unlock: Lose on the first click twice in a row."
		BadgeTypes.BadgeType.ECLIPSE:
			hoverName = "Eclipse"
			hoverDesc = "After 3 opens, close all boxes."
			unlockText = "To Unlock: Get a winstreak of 3."
		BadgeTypes.BadgeType.SHRUNKEN:
			hoverName = "Hints"
			hoverDesc = "Reveal one box in each row, but not its location."
			unlockText = "To Unlock: Win 15 times."

func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	if mousePos.x >= global_position.x  and mousePos.x <= global_position.x + 75 and mousePos.y >= global_position.y - 32 and mousePos.y <= global_position.y + 32:
		updateTooltipForMe()

func updateTooltipForMe():
	var curStatus
	if unlocked:
		curStatus = "Selected" if enabled else "Not Selected"
	else:
		curStatus = "Locked. " + unlockText
	get_parent().get_parent().get_node("Tooltip").setup(hoverName, curStatus, hoverDesc)

func unlockBadge():
	unlocked = true
	refreshOutline()

func checkWins():
	match (type):
		BadgeTypes.BadgeType.REVEAL_2_RANDOM:
			if get_parent().get_parent().wins >= 5:
				unlockBadge()
		BadgeTypes.BadgeType.ECLIPSE:
			if get_parent().get_parent().winstreak >= 3:
				unlockBadge()
		BadgeTypes.BadgeType.SHRUNKEN:
			if get_parent().get_parent().wins >= 15:
				unlockBadge()
		
func refreshOutline():
	if unlocked:
		if enabled:
			$Outline.texture = load("res://boxImgs/outlineClicked.png")
		else:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
	else:
		$Outline.texture = load("res://boxImgs/outlineClosed.png")

func _on_button_button_up() -> void:
	if unlocked:
		if enabled:
			enabled = false
			refreshOutline()
		else:
			enabled = true
			refreshOutline()
			for badge in get_parent().get_children():
				if badge != self:
					badge.enabled = false
					badge.refreshOutline()

func onRunStart():
	if enabled:
		match (type):
			BadgeTypes.BadgeType.REVEAL_2_RANDOM:
				get_parent().get_parent().reveal_random()
			BadgeTypes.BadgeType.LOSSES_TO_WINS:
				for box in get_parent().get_parent().boxes:
					if box.type == BoxTypes.LOSS or box.type == BoxTypes.JUMPSCARE:
						box.loadType(BoxTypes.BOOKS)
			BadgeTypes.BadgeType.ECLIPSE:
				get_parent().get_parent().add_status(StatusTypes.ECLIPSE, 3)
			BadgeTypes.BadgeType.SHRUNKEN:
				get_parent().get_parent().destroy_bottom_two_rows()
