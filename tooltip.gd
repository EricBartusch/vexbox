extends Control

var hovered = false
var reInitThisTurn = 0

func setup(name, status, desc):
	$BadgeProgressBar.visible = false
	$OpensTexture.visible = false
	$OpensText.visible = false
	$WinsTexture.visible = false
	$WinsText.visible = false
	$BPTexture.visible = false
	$BPText.visible = false
	hovered = true
	reInitThisTurn = 5
	$Header.text = name
	$Status.text = status
	$Description.text = desc

func setupProgressBar(cur, max, bp):
	if max > -1:
		$BadgeProgressBar.visible = true
		$BadgeProgressBar.value = cur
		$BadgeProgressBar.max_value = max
		$BadgeProgressBar/BadgeProgressText.text = str(cur) + "/" + str(max)
	$BPTexture.visible = true
	$BPText.visible = true
	$BPText.text = str(bp)

func setupStats(opens, wins):
	$OpensTexture.visible = true
	$OpensText.visible = true
	if wins > 0:
		$WinsTexture.visible = true
		$WinsText.visible = true
		$WinsText.text = str(wins)
	$OpensText.text = str(opens)
	

func _process(delta):
	if hovered:
		hovered = false
	else:
		$Header.text = ""
		$Status.text = ""
		$Description.text = ""
		$BadgeProgressBar.visible = false
		$OpensTexture.visible = false
		$OpensText.visible = false
		$WinsTexture.visible = false
		$WinsText.visible = false
		$BPTexture.visible = false
		$BPText.visible = false
