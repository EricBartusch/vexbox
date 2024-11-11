extends Control

var revealed = false
var just_opened = false
var open = false
var type = -1
var nameText = ""
var tooltipText = ""
var revealedImg
var row = -1
var col = -1
var destroyed = false
var special = -1
var customNum = -1
var fNum = -1

func set_custom_num(val):
	customNum = val
	$Number.visible = true
	$Number.text = str(val)

func hide_custom_num():
	$Number.visible = false
	customNum = -1
	$Number.text = "15"

func destroyBox():
	if type != BoxTypes.BEDROCK:
		destroyed = true
		visible = false
		hide_custom_num()
		if type == BoxTypes.EGG and open:
			lg("The Egg has hatched!")
			get_parent().win()
		elif type == BoxTypes.WORLDBEARER and open:
			lg("The Worldbearer has fallen!")
			get_parent().lose()
	else:
		var will_be_destroyed = false
		for box in get_parent().boxes:
			if box.type == BoxTypes.METEOR and box.open:
				will_be_destroyed = true
				break
		if will_be_destroyed:
			destroyed = true
			visible = false
			hide_custom_num()
			lg("The Bedrock was destroyed!")
			get_parent().win()

func reviveBox():
	if destroyed:
		destroyed = false
		visible = true
		closeBox()

func load(new_type, new_row, new_col):
	loadType(new_type)
	row = new_row
	col = new_col

func loadType(new_type):
	hide_custom_num()
	type = new_type
	load_text()
	load_img()

func load_text():
	match type:
		BoxTypes.WINNER:
			nameText = "Winner Box"
			tooltipText = "On Open: Win."
		BoxTypes.LOSS:
			nameText = "Loser Box"
			tooltipText = "On Open: Lose."
		BoxTypes.EMPTY:
			nameText = "Empty Box"
			tooltipText = "This box is empty!"
		BoxTypes.REVEAL_RANDOM:
			nameText = "Seer Box"
			tooltipText = "On Open: Reveal a random other box."
		BoxTypes.REVEAL_ROW:
			nameText = "Horizontal Sight Box"
			tooltipText = "On Open: Reveal all boxes in this row."
		BoxTypes.ONE_GOLD:
			nameText = "Cheap Box"
			tooltipText = "On Open: Gain 1 Gold."
		BoxTypes.POISON:
			nameText = "Poison Box"
			tooltipText = "On Open: Become Poisoned. You lose after 8 opens."
		BoxTypes.ANTIDOTE:
			nameText = "Antidote Box"
			tooltipText = "On Open: If you're Poisoned, remove your Poison. If this is adjacent to an open Viral Box, win."
		BoxTypes.EXPLODING:
			nameText = "Boom Box"
			tooltipText = "After you open a box, explodes, destroying itself and adjacent boxes."
		BoxTypes.PAY_FOR_REVEALS:
			nameText = "Deposit Box"
			tooltipText = "On Click: Spend 1 Gold to reveal a random adjacent box."
		BoxTypes.TWO_GOLD:
			nameText = "Change Box"
			tooltipText = "On Open: Gain 2 Gold."
		BoxTypes.SAFETY:
			nameText = "Safety Box"
			tooltipText = "On Open: The next time you click an unrevealed box, reveal it instead of opening it."
		BoxTypes.STAR:
			nameText = "Star Box"
			tooltipText = "On Open: If you've opened every adjacent box, win."
		BoxTypes.SHADOW:
			nameText = "Shadow Box"
			tooltipText = "On Open: Close a random other opened box."
		BoxTypes.JUMPSCARE:
			nameText = "Jumpscare Box"
			tooltipText = "On Open: If this was the first box you opened this game, lose."
		BoxTypes.FIRE:
			nameText = "Flaming Box"
			tooltipText = "On Open: Transform a random adjacent closed box into a Flaming Box."
		BoxTypes.THREE_GOLD:
			nameText = "Golden Box"
			tooltipText = "On Open: Gain 3 Gold."
		BoxTypes.SPEND_TO_WIN:
			nameText = "Crown Box"
			tooltipText = "On Click: Spend 6 Gold to win."
		BoxTypes.REVEAL_CORNERS:
			nameText = "Tri-Gaze Box"
			tooltipText = "On Open: Reveal the corner boxes."
		BoxTypes.SWORD:
			nameText = "Sword Box"
			tooltipText = "Lets you slay the Dragon."
		BoxTypes.DRAGON:
			nameText = "Dragon Box"
			tooltipText = "On Open: If the Sword is open, win. Otherwise, lose."
		BoxTypes.THREE_D:
			nameText = "3D Box"
			tooltipText = "On Open: Reveal 3 random boxes."
		BoxTypes.BOOKS:
			nameText = "Book Box"
			tooltipText = "On Open: If 11 or more boxes are open, win."
		BoxTypes.CLOCK:
			nameText = "Clock Box"
			tooltipText = "On Open: In 20 seconds, lose."
		BoxTypes.CLOSE_ADJACENT:
			nameText = "Collapse Box"
			tooltipText = "On Open: Close all adjacent boxes."
		BoxTypes.GHOST:
			nameText = "Ghost Box"
			tooltipText = "On Open: Transform 2 random boxes into Loser Boxes."
		BoxTypes.POVERTY:
			nameText = "Bankrupt Box"
			tooltipText = "On Open: Lose all your Gold."
		BoxTypes.SACRIFICE:
			nameText = "Sacrifical Box"
			tooltipText = "On Click: Destroy a random box, then reveal a random box. Usable 5 times."
		BoxTypes.INCOME:
			nameText = "Bank Box"
			tooltipText = "Whenever you open another box, 1/3 chance to gain 1 Gold."
		BoxTypes.BOSS:
			nameText = "Boss Box"
			tooltipText = "On Open: After opening 12 boxes, win."
		BoxTypes.SHY:
			nameText = "Shy Box"
			tooltipText = "Whenever you open another box, 1/3 chance to close this."
		BoxTypes.MIMIC:
			nameText = "Mimic Box"
			tooltipText = "If revealed, is revealed as a random other box. On Open: 1/3 chance to lose."
		BoxTypes.CURSE:
			nameText = "Curse Box"
			tooltipText = "On Open: The next time you would win, you don't."
		BoxTypes.PAY_FOR_SHIELD:
			nameText = "Close Spender Box"
			tooltipText = "On Click: Spend 1 Gold to close a random other open box."
		BoxTypes.HEART:
			nameText = "Heart Box"
			tooltipText = "On Open: For 3 opens, you can't lose."
		BoxTypes.MUSIC:
			nameText = "Music Box"
			tooltipText = "On Open: Play the music."
		BoxTypes.SUS:
			nameText = "Sus Box"
			tooltipText = "On Open: Transform 2 random boxes into Mimic Boxes."
		BoxTypes.SPEEDRUN:
			nameText = "Speedrun Box"
			tooltipText = "On Open: If this was the first box you opened this game, win."
		BoxTypes.DEMOLITION:
			nameText = "Demolition Box"
			tooltipText = "On Open: Destroy the next box you click instead of opening or using it."
		BoxTypes.HEARTBREAK:
			nameText = "Heartbreak Box"
			tooltipText = "Whenever you open another box, 1/10 chance to lose."
		BoxTypes.ROWBOMB:
			nameText = "Rowbomb Box"
			tooltipText = "After you open a box, explodes, destroying all boxes in its row."
		BoxTypes.CLOSENEXT:
			nameText = "Tape Box"
			tooltipText = "On Open: Close the next open non-Tape box you click."
		BoxTypes.AUTOOPEN:
			nameText = "Auto-Box"
			tooltipText = "Whenever you open another box, opens a random adjacent box."
		BoxTypes.ROWWIN:
			nameText = "Rowwin Box"
			tooltipText = "On Open: If all boxes in this row are opened, win."
		BoxTypes.TEACHER:
			nameText = "Big Brain Box"
			tooltipText = "Whenever you open another box, reveal a random adjacent box."
		BoxTypes.ARMAGEDDON:
			nameText = "Armageddon Box"
			tooltipText = "After you open 3 boxes, destroy this and all but the outer rim of boxes."
		BoxTypes.BEDROCK:
			nameText = "Bedrock Box"
			tooltipText = "Can't be destroyed, but if you do, win."
		BoxTypes.CLOAK:
			nameText = "Cloak Box"
			tooltipText = "On Open: If the Wand and Hat Boxes are open, win."
		BoxTypes.DESERT:
			nameText = "Deserted Box"
			tooltipText = "On Open: If 11 or more boxes are destroyed, win."
		BoxTypes.FAIRY:
			nameText = "Fairy in a Box"
			tooltipText = "On Open: Transform a random unrevealed box into a Fairy Box. If 4 Fairy Boxes are open, win."
		BoxTypes.HAT:
			nameText = "Hat Box"
			tooltipText = "On Open: If the Cloak and Wand Boxes are open, win."
		BoxTypes.INVERT:
			nameText = "Inversion Box"
			tooltipText = "On Open: Invert winning and losing for the rest of the game."
		BoxTypes.SELFDESTRUCT:
			nameText = "Self-Destruct Box"
			tooltipText = "After you open a box, destroys itself."
		BoxTypes.WAND:
			nameText = "Wand Box"
			tooltipText = "On Open: If the Hat and Cloak Boxes are open, win."
		BoxTypes.INSTAOPEN:
			nameText = "Insta-Opener Box"
			tooltipText = "On Open: Open the boxes right and left of this."
		BoxTypes.BLACKJACK:
			nameText = "Blackjack Box"
			tooltipText = "On Open: If 21 boxes are open, win. If more than 21 are open, lose."
		BoxTypes.EGG:
			nameText = "Egg Box"
			tooltipText = "If this box is destroyed while open, win."
		BoxTypes.INFERNO:
			nameText = "Inferno Box"
			tooltipText = "On Click: If 10 or more boxes are open Fire Boxes, win."
		BoxTypes.KEY:
			nameText = "Key Box"
			tooltipText = "On Open: If the next box you open is a Lock Box, win."
		BoxTypes.LOCK:
			nameText = "Lock Box"
			tooltipText = "Maybe a key could open this..?"
		BoxTypes.MATCH:
			nameText = "Matchbox"
			tooltipText = "On Open: Transform a random other box into a Fire Box."
		BoxTypes.PANDORAS:
			nameText = "Pandora's Box"
			tooltipText = "On Open: Transform all other revealed boxes into Loser Boxes."
		BoxTypes.REVIVAL:
			nameText = "Revival Box"
			tooltipText = "On Open: Revive 5 random destroyed boxes. (Boxes are revived closed.)"
		BoxTypes.SMARTBOMB:
			nameText = "Smart Bomb Box"
			tooltipText = "On Open: Reveal all adjacent boxes. After you open a box, explodes, destroying itself and adjacent boxes."
		BoxTypes.TERRITORY:
			nameText = "Territory Box"
			tooltipText = "On Open: For the next 4 opens, you can only open boxes adjacent to open boxes."
		BoxTypes.WORLDBEARER:
			nameText = "Worldbearer Box"
			tooltipText = "If this box is destroyed while open, lose."
		BoxTypes.PRINCESS:
			nameText = "Princess Box"
			tooltipText = "On Open: If the Dragon is revealed, lose. Otherwise, gain 3 Gold."
		BoxTypes.MINE:
			nameText = "Mine Box"
			tooltipText = "Whenever you open an adjacent box, gain 1 Gold."
		BoxTypes.CLONE:
			nameText = "Clone Box"
			tooltipText = "After you open 3 boxes, becomes a closed copy of a random box."
		BoxTypes.GAMER:
			nameText = "Gamer Box"
			tooltipText = "On Open: If you won the last run, win."
		BoxTypes.MAGNIFYING:
			nameText = "Magnifying Box"
			tooltipText = "On Click: Spend 1 Gold to reveal a random box."
		BoxTypes.VIRUS:
			nameText = "Viral Box"
			tooltipText = "After you open a box, transform adjacent open boxes into Viral Boxes."
		BoxTypes.STARVE:
			nameText = "Hungry Box"
			tooltipText = "On Open: Transform 5 random unrevealed boxes into Food Boxes. After 6 opens without opening a Food Box, lose."
		BoxTypes.SPIRE:
			nameText = "Ascended Box"
			tooltipText = "On Open: If you don't have a Badge equipped, transform the Empty Box into a Winner Box."
		BoxTypes.CRUMBLING:
			nameText = "Crumbling Box"
			tooltipText = "After you open a box, destroy the top box (right to left)."
		BoxTypes.TRIPLEPLAY:
			nameText = "Three Box"
			tooltipText = "On Open: If this is the third time you've opened this box, win."
		BoxTypes.FOOD:
			nameText = "Food Box"
			tooltipText = "Yum."
		BoxTypes.ALLSEEINGEYE:
			nameText = "All Seeing Box"
			tooltipText = "On Open: Reveal 10 random boxes. After you open 3 boxes, lose."
		BoxTypes.WATERFALL:
			nameText = "Waterfall Box"
			tooltipText = "On Open: If in the bottom row, win. Otherwise, transform a random box in the row below into a Waterfall Box."
		BoxTypes.METEOR:
			nameText = "Meteor Box"
			tooltipText = "The Bedrock Box can be destroyed."
		BoxTypes.PAINT:
			nameText = "Paint Box"
			tooltipText = "On Open: Paint the background a random color."
		BoxTypes.ICE:
			nameText = "Ice Box"
			tooltipText = "On Open: You can't open boxes in this row for 3 opens."
		BoxTypes.BULLSEYE:
			nameText = "Bullseye Box"
			tooltipText = "On Open: If no adjacent boxes are revealed, reveal all adjacent boxes."
		BoxTypes.CONFIDENTIAL:
			nameText = "Espionage Box"
			tooltipText = "On Open: If 18 or more boxes are revealed, win."
		BoxTypes.FISHING_ROD:
			nameText = "Fishing Box"
			tooltipText = "On Open: Transform 3 random unrevealed boxes into Fish Boxes."
		BoxTypes.IMPATIENT:
			nameText = "Impatient Box"
			tooltipText = "Whenever you reveal a box in this row, open it."
		BoxTypes.TRANSMOG:
			nameText = "Transmog Box"
			tooltipText = "On Open: The next 2 times you click a revealed box, transform it into a random other box instead of opening or using it."
		BoxTypes.STUCK:
			nameText = "Softlock Box"
			tooltipText = "If you can't open any boxes, you win."
		BoxTypes.FISH:
			nameText = "Fish Box"
			tooltipText = "On Open: If 3 or more Fish Boxes are open, win."
		BoxTypes.DNA:
			nameText = "DNA Box"
			tooltipText = "On Open: Transform all adjacent boxes into the same random box."
		BoxTypes.DAREDEVIL:
			nameText = "Daredevil Box"
			tooltipText = "On Click: 20% chance to win. 30% chance to lose."

func load_img():
	match type:
		BoxTypes.WINNER:
			revealedImg = load("res://boxImgs/WINNER.png")
		BoxTypes.LOSS:
			revealedImg = load("res://boxImgs/LOSS.png")
		BoxTypes.EMPTY:
			revealedImg = load("res://boxImgs/EMPTY.png")
		BoxTypes.REVEAL_RANDOM:
			revealedImg = load("res://boxImgs/REVEAL_RANDOM.png")
		BoxTypes.REVEAL_ROW:
			revealedImg = load("res://boxImgs/REVEAL_ROW.png")
		BoxTypes.ONE_GOLD:
			revealedImg = load("res://boxImgs/ONE_GOLD.png")
		BoxTypes.POISON:
			revealedImg = load("res://boxImgs/POISON.png")
		BoxTypes.ANTIDOTE:
			revealedImg = load("res://boxImgs/ANTIDOTE.png")
		BoxTypes.EXPLODING:
			revealedImg = load("res://boxImgs/EXPLODING.png")
		BoxTypes.PAY_FOR_REVEALS:
			revealedImg = load("res://boxImgs/PAY_FOR_REVEALS.png")
		BoxTypes.SHADOW:
			revealedImg = load("res://boxImgs/boxShadow.png")
		BoxTypes.SAFETY:
			revealedImg = load("res://boxImgs/boxSafety.png")
		BoxTypes.STAR:
			revealedImg = load("res://boxImgs/boxStar.png")
		BoxTypes.TWO_GOLD:
			revealedImg = load("res://boxImgs/boxTwoDollars.png")
		BoxTypes.JUMPSCARE:
			revealedImg = load("res://boxImgs/boxJumpscare.png")
		BoxTypes.DRAGON:
			revealedImg = load("res://boxImgs/boxDragon.png")
		BoxTypes.SPEND_TO_WIN:
			revealedImg = load("res://boxImgs/boxCrown.png")
		BoxTypes.REVEAL_CORNERS:
			revealedImg = load("res://boxImgs/boxRevealCorners.png")
		BoxTypes.SWORD:
			revealedImg = load("res://boxImgs/boxSword.png")
		BoxTypes.THREE_GOLD:
			revealedImg = load("res://boxImgs/boxThreeGold.png")
		BoxTypes.FIRE:
			revealedImg = load("res://boxImgs/boxFire.png")
		BoxTypes.THREE_D:
			revealedImg = load("res://boxImgs/box3D.png")
		BoxTypes.BOOKS:
			revealedImg = load("res://boxImgs/boxBooks.png")
		BoxTypes.CLOCK:
			revealedImg = load("res://boxImgs/boxClock.png")
		BoxTypes.GHOST:
			revealedImg = load("res://boxImgs/boxGhost.png")
		BoxTypes.POVERTY:
			revealedImg = load("res://boxImgs/boxPoverty.png")
		BoxTypes.SACRIFICE:
			revealedImg = load("res://boxImgs/boxSacrifice.png")
		BoxTypes.CLOSE_ADJACENT:
			revealedImg = load("res://boxImgs/boxCloseAdjacent.png")
		BoxTypes.INCOME:
			revealedImg = load("res://boxImgs/boxIncome.png")
		BoxTypes.BOSS:
			revealedImg = load("res://boxImgs/boxBoss.png")
		BoxTypes.SHY:
			revealedImg = load("res://boxImgs/boxShy.png")
		BoxTypes.MIMIC:
			revealedImg = load("res://boxImgs/boxMimic.png")
		BoxTypes.CURSE:
			revealedImg = load("res://boxImgs/boxCurse.png")
		BoxTypes.PAY_FOR_SHIELD:
			revealedImg = load("res://boxImgs/boxSpendForShield.png")
		BoxTypes.HEART:
			revealedImg = load("res://boxImgs/boxHeart.png")
		BoxTypes.MUSIC:
			revealedImg = load("res://boxImgs/boxMusic.png")
		BoxTypes.SUS:
			revealedImg = load("res://boxImgs/boxSus.png")
		BoxTypes.SPEEDRUN:
			revealedImg = load("res://boxImgs/boxSpeedrun.png")
		BoxTypes.DEMOLITION:
			revealedImg = load("res://boxImgs/boxWrecker.png")
		BoxTypes.HEARTBREAK:
			revealedImg = load("res://boxImgs/boxHeartbreak.png")
		BoxTypes.ROWBOMB:
			revealedImg = load("res://boxImgs/boxRowbomb.png")
		BoxTypes.CLOSENEXT:
			revealedImg = load("res://boxImgs/boxCloser.png")
		BoxTypes.AUTOOPEN:
			revealedImg = load("res://boxImgs/boxAutoOpen.png")
		BoxTypes.ROWWIN:
			revealedImg = load("res://boxImgs/boxHorizWin.png")
		BoxTypes.TEACHER:
			revealedImg = load("res://boxImgs/boxBigBrain.png")
		BoxTypes.ARMAGEDDON:
			revealedImg = load("res://boxImgs/boxArmageddon.png")
		BoxTypes.BEDROCK:
			revealedImg = load("res://boxImgs/boxBedrock.png")
		BoxTypes.CLOAK:
			revealedImg = load("res://boxImgs/boxCloak.png")
		BoxTypes.DESERT:
			revealedImg = load("res://boxImgs/boxDesert.png")
		BoxTypes.FAIRY:
			revealedImg = load("res://boxImgs/boxFairy.png")
		BoxTypes.HAT:
			revealedImg = load("res://boxImgs/boxHat.png")
		BoxTypes.INVERT:
			revealedImg = load("res://boxImgs/boxInversion.png")
		BoxTypes.SELFDESTRUCT:
			revealedImg = load("res://boxImgs/boxSelfDestruct.png")
		BoxTypes.WAND:
			revealedImg = load("res://boxImgs/boxWand.png")
		BoxTypes.INSTAOPEN:
			revealedImg = load("res://boxImgs/boxInstaOpen.png")
		BoxTypes.BLACKJACK:
			revealedImg = load("res://boxImgs/blackjackBox.png")
		BoxTypes.EGG:
			revealedImg = load("res://boxImgs/eggBox.png")
		BoxTypes.INFERNO:
			revealedImg = load("res://boxImgs/infernoBox.png")
		BoxTypes.KEY:
			revealedImg = load("res://boxImgs/keyBox.png")
		BoxTypes.LOCK:
			revealedImg = load("res://boxImgs/lockBox.png")
		BoxTypes.MATCH:
			revealedImg = load("res://boxImgs/matchBox.png")
		BoxTypes.PANDORAS:
			revealedImg = load("res://boxImgs/pandorasBox.png")
		BoxTypes.REVIVAL:
			revealedImg = load("res://boxImgs/revivalBox.png")
		BoxTypes.SMARTBOMB:
			revealedImg = load("res://boxImgs/smartBombBox.png")
		BoxTypes.TERRITORY:
			revealedImg = load("res://boxImgs/territoryBox.png")
		BoxTypes.WORLDBEARER:
			revealedImg = load("res://boxImgs/worldbearerBox.png")
		BoxTypes.PRINCESS:
			revealedImg = load("res://boxImgs/princessBox.png")
		BoxTypes.MINE:
			revealedImg = load("res://boxImgs/mineBox.png")
		BoxTypes.CLONE:
			revealedImg = load("res://boxImgs/clonerBox.png")
		BoxTypes.GAMER:
			revealedImg = load("res://boxImgs/boxGamer.png")
		BoxTypes.MAGNIFYING:
			revealedImg = load("res://boxImgs/magnifyingBox.png")
		BoxTypes.VIRUS:
			revealedImg = load("res://boxImgs/viralBox.png")
		BoxTypes.STARVE:
			revealedImg = load("res://boxImgs/starvingBox.png")
		BoxTypes.SPIRE:
			revealedImg = load("res://boxImgs/boxAscended.png")
		BoxTypes.CRUMBLING:
			revealedImg = load("res://boxImgs/boxCrumbling.png")
		BoxTypes.TRIPLEPLAY:
			revealedImg = load("res://boxImgs/boxRunicThree.png")
		BoxTypes.FOOD:
			revealedImg = load("res://boxImgs/foodBox.png")
		BoxTypes.ALLSEEINGEYE:
			revealedImg = load("res://boxImgs/boxAllSeeingEye.png")
		BoxTypes.WATERFALL:
			revealedImg = load("res://boxImgs/boxWaterfall.png")
		BoxTypes.METEOR:
			revealedImg = load("res://boxImgs/boxMeteors.png")
		BoxTypes.DAREDEVIL:
			revealedImg = load("res://boxImgs/daredevilBox.png")
		BoxTypes.PAINT:
			revealedImg = load("res://boxImgs/boxPaint.png")
		BoxTypes.ICE:
			revealedImg = load("res://boxImgs/boxIce.png")
		BoxTypes.BULLSEYE:
			revealedImg = load("res://boxImgs/bullseyeBox.png")
		BoxTypes.CONFIDENTIAL:
			revealedImg = load("res://boxImgs/classifiedBox.png")
		BoxTypes.FISHING_ROD:
			revealedImg = load("res://boxImgs/fishingBox.png")
		BoxTypes.IMPATIENT:
			revealedImg = load("res://boxImgs/impatientBox.png")
		BoxTypes.TRANSMOG:
			revealedImg = load("res://boxImgs/alchemyBox.png")
		BoxTypes.STUCK:
			revealedImg = load("res://boxImgs/stuckBox.png")
		BoxTypes.FISH:
			revealedImg = load("res://boxImgs/fishBox.png")
		BoxTypes.DNA:
			revealedImg = load("res://boxImgs/boxDNA.png")
		
	if revealed:
		$Sprite2D.texture = revealedImg

func revealBox():
	if !destroyed:
		var was_already_revealed = revealed
		revealed = true
		if type == BoxTypes.MIMIC:
			if special == -1:
				var replacement = BoxTypes.MIMIC
				while replacement == BoxTypes.MIMIC:
					replacement = get_parent().rng.randi_range(0, BoxTypes.MAX - 1)
					special = replacement
			type = special

			load_img()
			load_text()
			$Sprite2D.texture = revealedImg
			type = BoxTypes.MIMIC
		else:
			$Sprite2D.texture = revealedImg
		if !open:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
		if !was_already_revealed:
			lg(nameText + " was revealed!")
			var willOpen = false
			for box in get_parent().rows[row]:
				if box.type == BoxTypes.IMPATIENT and !box.destroyed and box.open:
					willOpen = true
			if willOpen:
				get_parent().logToLog(null, "Impatient Box opens the revealed box!")
				openBox()

func openBox():
	if !destroyed and !open:
		get_parent().get_node("OpenFXPlayer").play()
		revealed = true
		just_opened = true
		open = true
		$Outline.texture = load("res://boxImgs/outlineClicked.png")
		load_img()
		lg("Opened " + nameText)
		activateEffects()

func closeBox():
	if open:
		lg(nameText + " was closed.")
		open = false
		if type != BoxTypes.TRIPLEPLAY:
			hide_custom_num()
		$Outline.texture = load("res://boxImgs/outlineRevealed.png")

func activateEffects():
	match type:
		BoxTypes.WINNER:
			get_parent().win()
		BoxTypes.LOSS:
			get_parent().lose()
		BoxTypes.EMPTY:
			pass
		BoxTypes.REVEAL_RANDOM:
			get_parent().reveal_random()
		BoxTypes.REVEAL_ROW:
			get_parent().reveal_row(row)
		BoxTypes.ONE_GOLD:
			get_parent().add_status(StatusTypes.GOLD, 1)
		BoxTypes.POISON:
			get_parent().add_status(StatusTypes.POISON, 8)
		BoxTypes.ANTIDOTE:
			if (get_parent().has_status(StatusTypes.POISON)):
				get_parent().remove_status(StatusTypes.POISON)
			for box in get_adjacent_boxes(false, false):
				if box.open and box.type == BoxTypes.VIRUS:
					get_parent().win()
		BoxTypes.JUMPSCARE:
			if get_parent().opens == 0:
				get_parent().lose()
		BoxTypes.SAFETY:
			get_parent().add_status(StatusTypes.SAFETY, 1)
		BoxTypes.SHADOW:
			close_random_other()
		BoxTypes.TWO_GOLD:
			get_parent().add_status(StatusTypes.GOLD, 2)
		BoxTypes.STAR:
			var adjacents = get_adjacent_boxes(false, false)
			var winning = true
			for box in adjacents:
				if !box.open:
					winning = false
			if winning:
				get_parent().win()
		BoxTypes.REVEAL_CORNERS:
			get_parent().reveal_corners()
		BoxTypes.DRAGON:
			var winning = false
			for box in get_parent().boxes:
				if box.type == BoxTypes.SWORD and box.open and !box.destroyed:
					winning = true
			if winning:
				get_parent().win()
			else:
				get_parent().lose()
		BoxTypes.SWORD:
			pass
		BoxTypes.THREE_GOLD:
			get_parent().add_status(StatusTypes.GOLD, 3)
		BoxTypes.SPEND_TO_WIN:
			pass
		BoxTypes.FIRE:
			var toChange = get_adjacent_boxes(false, true)
			var result = []
			for box in toChange:
				if box.type != BoxTypes.FIRE:
					result.append(box)
			if result.size() > 0:
				var toHit = result.pick_random()
				toHit.loadType(BoxTypes.FIRE)
		BoxTypes.GHOST:
			for i in 2:
				var valids = []
				for box in get_parent().boxes:
					if !box.destroyed and box != self:
						valids.append(box)
				var toChange = valids.pick_random()
				toChange.loadType(BoxTypes.LOSS)
		BoxTypes.CLOCK:
			set_custom_num(20)
			fNum = 1
		BoxTypes.BOOKS:
			var count = 0
			for box in get_parent().boxes:
				if box.open and !box.destroyed:
					count += 1
			if count >= 11:
				get_parent().win()
		BoxTypes.SACRIFICE:
			set_custom_num(5)
		BoxTypes.POVERTY:
			if (get_parent().has_status(StatusTypes.GOLD)):
				get_parent().remove_status(StatusTypes.GOLD)
		BoxTypes.CLOSE_ADJACENT:
			for box in get_adjacent_boxes(false, false):
				if box.open:
					box.closeBox()
		BoxTypes.THREE_D:
			for i in 3:
				get_parent().reveal_random()
		BoxTypes.INCOME:
			pass
		BoxTypes.BOSS:
			set_custom_num(12)
		BoxTypes.SHY:
			pass
		BoxTypes.MIMIC:
			if get_parent().rng.randi_range(0, 2) == 2:
				get_parent().lose()
		BoxTypes.CURSE:
			get_parent().add_status(StatusTypes.CURSE, 1)
		BoxTypes.PAY_FOR_SHIELD:
			pass
		BoxTypes.HEART:
			get_parent().add_status(StatusTypes.HEART, 3)
		BoxTypes.MUSIC:
			get_parent().get_node("MusicPlayer").play()
			pass
		BoxTypes.SUS:
			for i in 2:
				var list = []
				for box in get_parent().boxes:
					if box.type != BoxTypes.MIMIC and !box.destroyed:
						list.append(box)
				var toChange = list.pick_random()
				var oldType = toChange.type
				toChange.loadType(BoxTypes.MIMIC)
				toChange.special = oldType
				if toChange.revealed and not toChange.open:
					toChange.revealBox()
		BoxTypes.SPEEDRUN:
			if get_parent().opens == 0:
				get_parent().win()
		BoxTypes.DEMOLITION:
			get_parent().add_status(StatusTypes.DEMOLISH, 1)
		BoxTypes.CLOSENEXT:
			get_parent().add_status(StatusTypes.CLOSENEXT, 1)
		BoxTypes.ROWWIN:
			var willWin = true
			for box in get_parent().rows[row]:
				if !box.open and !box.destroyed:
					willWin = false
			if willWin:
				get_parent().win()
		BoxTypes.ARMAGEDDON:
			set_custom_num(3)
			lg("3 opens to Armageddon!")
		BoxTypes.CLOAK:
			var hasWand = false
			var hasHat = false
			for box in get_parent().boxes:
				if box.type == BoxTypes.WAND and !box.destroyed and box.open:
					hasWand = true
				if box.type == BoxTypes.HAT and !box.destroyed and box.open:
					hasHat = true
			if hasWand and hasHat:
				get_parent().win()
		BoxTypes.DESERT:
			var count = 0
			for box in get_parent().boxes:
				if box.destroyed:
					count += 1
			if count >= 11:
				get_parent().win()
		BoxTypes.FAIRY:
			var valids = []
			for box in get_parent().boxes:
				if !box.destroyed and !box.revealed and box.type != BoxTypes.FAIRY:
					valids.append(box)
			if valids.size() > 0:
				var toChange = valids.pick_random()
				toChange.loadType(BoxTypes.FAIRY)
			var count = 0
			for box in get_parent().boxes:
				if box.open and !box.destroyed and box.type == BoxTypes.FAIRY:
					count += 1
			if count >= 4:
				get_parent().win()
		BoxTypes.HAT:
			var hasWand = false
			var hasCloak = false
			for box in get_parent().boxes:
				if box.type == BoxTypes.WAND and !box.destroyed and box.open:
					hasWand = true
				if box.type == BoxTypes.CLOAK and !box.destroyed and box.open:
					hasCloak = true
			if hasWand and hasCloak:
				get_parent().win()
		BoxTypes.INVERT:
			if get_parent().has_status(StatusTypes.INVERSION):
				get_parent().remove_status(StatusTypes.INVERSION)
			else:
				get_parent().add_status(StatusTypes.INVERSION, 1)
		BoxTypes.WAND:
			var hasHat = false
			var hasCloak = false
			for box in get_parent().boxes:
				if box.type == BoxTypes.HAT and !box.destroyed and box.open:
					hasHat = true
				if box.type == BoxTypes.CLOAK and !box.destroyed and box.open:
					hasCloak = true
			if hasHat and hasCloak:
				get_parent().win()
		BoxTypes.INSTAOPEN:
			var myRow = get_parent().rows[row]
			if col != 0:
				myRow[col-1].openBox()
			if col < myRow.size() - 1:
				myRow[col+1].openBox()
		BoxTypes.BLACKJACK:
			var count = 0
			for box in get_parent().boxes:
				if !box.destroyed and box.open:
					count += 1
			if count == 21:
				get_parent().win()
			elif count > 21:
				get_parent().lose()
		BoxTypes.KEY:
			get_parent().add_status(StatusTypes.KEY, 1)
		BoxTypes.LOCK:
			if get_parent().has_status(StatusTypes.KEY):
				get_parent().win()
		BoxTypes.MATCH:
			var list = []
			for box in get_parent().boxes:
				if box.type != BoxTypes.FIRE and !box.destroyed:
					list.append(box)
			var toChange = list.pick_random()
			toChange.loadType(BoxTypes.FIRE)
			if toChange.revealed:
				toChange.revealBox()
		BoxTypes.PANDORAS:
			for box in get_parent().boxes:
				if box != self and box.revealed and not box.destroyed:
					box.loadType(BoxTypes.LOSS)
		BoxTypes.REVIVAL:
			var valids = []
			for box in get_parent().boxes:
				if box.destroyed:
					valids.append(box)
			var siz = valids.size()
			for i in min(5, siz):
				var toRes = valids.pick_random()
				toRes.reviveBox()
				valids.erase(toRes)
		BoxTypes.SMARTBOMB:
			for box in get_adjacent_boxes(true, false):
				box.revealBox()
		BoxTypes.TERRITORY:
			get_parent().add_status(StatusTypes.TERRITORY, 4)
		BoxTypes.PRINCESS:
			var willDie = false
			for box in get_parent().boxes:
				if box.type == BoxTypes.DRAGON and box.revealed and not box.destroyed:
					willDie = true
			if willDie:
				get_parent().lose()
			else:
				get_parent().add_status(StatusTypes.GOLD, 3)
		BoxTypes.CLONE:
			set_custom_num(3)
		BoxTypes.GAMER:
			if get_parent().winstreak > 0:
				get_parent().win()
		BoxTypes.STARVE:
			for i in 5:
				var list = []
				for box in get_parent().boxes:
					if box.type != BoxTypes.FOOD and !box.destroyed and !box.revealed:
						list.append(box)
				var toChange = list.pick_random()
				toChange.loadType(BoxTypes.FOOD)
			set_custom_num(6)
		BoxTypes.FOOD:
			for box in get_parent().boxes:
				if box.type == BoxTypes.STARVE and box.open:
					box.set_custom_num(6)
					box.just_opened = true
		BoxTypes.SPIRE:
			var willActivate = true
			for badge in get_parent().get_node("BadgeList").get_children():
				if badge.enabled:
					willActivate = false
			if willActivate:
				for box in get_parent().boxes: 
					if box.type == BoxTypes.EMPTY:
						box.loadType(BoxTypes.WINNER)
		BoxTypes.TRIPLEPLAY:
			if customNum == -1:
				set_custom_num(1)
			else:
				set_custom_num(customNum + 1)
				if customNum == 3:
					get_parent().win()
		BoxTypes.ALLSEEINGEYE:
			for i in 10:
				get_parent().reveal_random()
			set_custom_num(3)
		BoxTypes.WATERFALL:
			if row == get_parent().totalRows:
				get_parent().win()
			else:
				var valids = []
				for box in get_parent().rows[row+1]:
					if !box.destroyed:
						valids.append(box)
				var toChange = valids.pick_random()
				toChange.loadType(BoxTypes.WATERFALL)
		BoxTypes.PAINT:
			var result = Color(get_parent().rng.randf_range(0, 1), get_parent().rng.randf_range(0, 1), get_parent().rng.randf_range(0, 1), 1)
			get_parent().get_node("ColorRect").color = result
		BoxTypes.ICE:
			set_custom_num(3)
		BoxTypes.BULLSEYE:
			var will_reveal = true
			for box in get_adjacent_boxes(false, false):
				if box.revealed:
					will_reveal = false
					break
			if will_reveal:
				for box in get_adjacent_boxes(true, true):
					box.revealBox()
		BoxTypes.CONFIDENTIAL:
			var count = 0
			for box in get_parent().boxes:
				if box.revealed and not box.destroyed:
					count += 1
			if count >= 18:
				lg("Espionage victory!")
				get_parent().win()
		BoxTypes.FISHING_ROD:
			for i in 3:
				var list = []
				for box in get_parent().boxes:
					if box.type != BoxTypes.FISH and !box.destroyed and !box.revealed:
						list.append(box)
				var toChange = list.pick_random()
				toChange.loadType(BoxTypes.FISH)
		BoxTypes.TRANSMOG:
			get_parent().add_status(StatusTypes.TRANSMOG, 2)
		BoxTypes.FISH:
			var count = 0
			for box in get_parent().boxes:
				if box.open and !box.destroyed and box.type == BoxTypes.FISH:
					count += 1
			if count >= 3:
				get_parent().win()
		BoxTypes.DNA:
			var newType = get_parent().rng.randi_range(0, BoxTypes.MAX-1)
			for box in get_adjacent_boxes(false, false):
				box.loadType(newType)
		

func updateTooltipForMe():
	var curName = "Unknown Box"
	var curStatus = "Closed"
	var curDesc = "What could be inside?"
	if revealed:
		if type == BoxTypes.MIMIC and special != -1 and revealed and not open:
			type = special
			load_text()
			curName = nameText
			curStatus = "Revealed"
			curDesc = tooltipText
			type = BoxTypes.MIMIC
			load_text()
		else:
			curName = nameText
			if open:
				curStatus = "Opened"
			else:
				curStatus = "Revealed"
			curDesc = tooltipText
	get_parent().get_node("Tooltip").setup(curName, curStatus, curDesc)

func _process(delta):
	if !destroyed:
		var mousePos = get_viewport().get_mouse_position()
		if mousePos.x >= global_position.x - 34 and mousePos.x <= global_position.x + 34 and mousePos.y >= global_position.y - 34 and mousePos.y <= global_position.y + 34:
			updateTooltipForMe()
		if open and get_parent().gameRunning:
			match (type):
				BoxTypes.CLOCK:
					fNum -= delta
					if fNum <= 0:
						fNum = 1
						if customNum > 0:
							if customNum == 1:
								lg("Time's up!")
								get_parent().lose()
							set_custom_num(customNum-1)

func on_click():
	if open and not just_opened and not destroyed and get_parent().gameRunning:
		match (type):
			BoxTypes.MINE:
				for box in get_adjacent_boxes(false, false):
					if get_parent().last_opened == box:
						lg("Mined some gold!")
						get_parent().add_status(StatusTypes.GOLD, 1)
			BoxTypes.EXPLODING:
				lg(nameText + " exploded!")
				for box in get_adjacent_boxes(false, false):
					get_parent().destroy_box(box)
				get_parent().destroy_box(self)
			BoxTypes.INCOME:
				if get_parent().rng.randi_range(0, 2) == 2:
					lg(nameText + " generated 1 Gold!")
					get_parent().add_status(StatusTypes.GOLD, 1)
			BoxTypes.SHY:
				if get_parent().rng.randi_range(0, 2) == 2:
					closeBox()
			BoxTypes.HEARTBREAK:
				if get_parent().rng.randi_range(0, 9) == 9:
					lg(nameText + " activated - oh no!")
					get_parent().lose()
			BoxTypes.ROWBOMB:
				lg(nameText + " exploded!")
				for box in get_parent().rows[row]:
					if box != self:
						get_parent().destroy_box(box)
				get_parent().destroy_box(self)
			BoxTypes.AUTOOPEN:
				var valids = get_adjacent_boxes(false, true)
				if valids.size() > 0:
					lg(nameText + " is opening a box!")
					var toOpen = valids.pick_random()
					toOpen.openBox()
					toOpen.just_opened = true
			BoxTypes.TEACHER:
				var valids = get_adjacent_boxes(true, false)
				if valids.size() > 0:
					lg(nameText + " activated!")
					var toReveal = valids.pick_random()
					toReveal.revealBox()
			BoxTypes.SELFDESTRUCT:
				lg(nameText + " exploded!")
				get_parent().destroy_box(self)
			BoxTypes.ARMAGEDDON:
				if customNum == 1:
					lg("Armageddon has arrived!")
					get_parent().clear_central()
					get_parent().destroy_box(self)
				else:
					set_custom_num(customNum - 1)
					lg(str(customNum) + " opens to Armageddon!")
			BoxTypes.SMARTBOMB:
				lg(nameText + " exploded!")
				for box in get_adjacent_boxes(false, false):
					get_parent().destroy_box(box)
				get_parent().destroy_box(self)
			BoxTypes.BOSS:
				if customNum > 0:
					if customNum == 1:
						get_parent().win()
					set_custom_num(customNum-1)
					if get_parent().gameRunning and customNum == 0:
							hide_custom_num()
			BoxTypes.CLONE:
				if customNum > 0:
					if customNum == 1:
						var found = get_parent().rng.randi_range(0, BoxTypes.MAX - 1)
						loadType(found)
						closeBox()
					else:
						set_custom_num(customNum - 1)
			BoxTypes.VIRUS:
				for box in get_adjacent_boxes(false, false):
					if box.revealed and box.open and box.type != BoxTypes.VIRUS:
						box.loadType(BoxTypes.VIRUS)
						box.just_opened = true
			BoxTypes.STARVE:
				if customNum > 0:
					if customNum == 1:
						lg("The Hungry Box starves!")
						get_parent().lose()
					set_custom_num(customNum - 1)
					if get_parent().gameRunning and customNum == 0:
							hide_custom_num()
			BoxTypes.CRUMBLING:
				for box in get_parent().boxes:
					if !box.destroyed:
						get_parent().destroy_box(box)
						break
			BoxTypes.ALLSEEINGEYE:
				if customNum > 0:
					if customNum == 1:
						lg("All Seeing Box activates!")
						get_parent().lose()
					set_custom_num(customNum - 1)
					if get_parent().gameRunning and customNum == 0:
							hide_custom_num()
			BoxTypes.ICE:
				if customNum > 0:
					if customNum == 1:
						lg("Ice Box has thawed!")
					set_custom_num(customNum - 1)
					if customNum == 0:
							hide_custom_num()
			BoxTypes.STUCK:
				# better later
				var willWin = true
				var territoryCheck = get_parent().has_status(StatusTypes.TERRITORY)
				for box in get_parent().boxes:
					if !box.open:
						if territoryCheck:
							var unclickable = true
							for other in box.get_adjacent_boxes(false, false):
								if other.open:
									unclickable = false
							if !unclickable:
								for other in get_parent().rows[box.row]:
									if other.type == BoxTypes.ICE and other.customNum > 0:
										unclickable = true
										break
								if !unclickable:
									willWin = false
									break
						else:
							var unclickable = false
							for other in get_parent().rows[box.row]:
								if other.type == BoxTypes.ICE and other.customNum > 0:
									unclickable = true
									break
							if !unclickable:
								willWin = false
								break
				if willWin:
					lg("You've softlocked! Softlock Box activates!")
					get_parent().win()
	just_opened = false

func on_self_clicked():
	match (type):
		BoxTypes.PAY_FOR_REVEALS:
			var valids = get_adjacent_boxes(true, false)
			if valids.size() > 0:
				if get_parent().status_amount(StatusTypes.GOLD) > 0:
					get_parent().get_node("ActivateFXPlayer").play()
					get_parent().change_status_amount(StatusTypes.GOLD, -1)
					var toReveal = valids.pick_random()
					toReveal.revealBox()
		BoxTypes.SPEND_TO_WIN:
			if get_parent().status_amount(StatusTypes.GOLD) >= 6:
				get_parent().change_status_amount(StatusTypes.GOLD, -6)
				get_parent().win()
		BoxTypes.SACRIFICE:
			if customNum > 0:
				get_parent().get_node("ActivateFXPlayer").play()
				var thingy = get_parent()
				var toChange = thingy.get_random_box()
				get_parent().destroy_box(toChange)
				thingy.reveal_random()
				set_custom_num(customNum - 1)
		BoxTypes.PAY_FOR_SHIELD:
			if get_parent().status_amount(StatusTypes.GOLD) >= 1:
				get_parent().get_node("ActivateFXPlayer").play()
				get_parent().change_status_amount(StatusTypes.GOLD, -1)
				close_random_other()
		BoxTypes.INFERNO:
			var count = 0
			for box in get_parent().boxes:
				if box.type == BoxTypes.FIRE and box.open:
					count += 1
			if count >= 10:
				get_parent().win()
		BoxTypes.MAGNIFYING:
			if get_parent().status_amount(StatusTypes.GOLD) >= 1:
				get_parent().get_node("ActivateFXPlayer").play()
				get_parent().change_status_amount(StatusTypes.GOLD, -1)
				get_parent().reveal_random()
		BoxTypes.DAREDEVIL:
			var result = get_parent().rng.randi_range(0, 9)
			if result <= 1:
				lg("Lucky! Daredevil Box made you win!")
				get_parent().win()
			elif result <= 4:
				lg("Daredevil Box made you lose!")
				get_parent().lose()
			else:
				lg("Daredevil Box didn't do anything!")
			
	get_parent().update_stat_texts()

func get_adjacent_boxes(notRevealed, notOpen):
	var result = []
	var myRow = get_parent().rows[row]
	if col != 0:
		result.append(myRow[col - 1])
	if col < myRow.size() - 1:
		result.append(myRow[col+1])
	if row > 0:
		var rowAbove = get_parent().rows[row-1]
		if col != 0:
			result.append(rowAbove[col - 1])
		if rowAbove.size() > col:
			result.append(rowAbove[col])
	if row < get_parent().totalRows:
		var rowBelow = get_parent().rows[row+1]
		result.append(rowBelow[col])
		result.append(rowBelow[col + 1])
	var holder = []
	for box in result:
		if !box.destroyed:
			holder.append(box)
	result = holder
	if notRevealed:
		var real = []
		for box in result:
			if !box.revealed:
				real.append(box)
		return real
	else:
		if notOpen:
			var real = []
			for box in result:
				if !box.open:
					real.append(box)
			return real
		else:
			return result

func innerOpen():
	get_parent().last_opened = self
	openBox()
	get_parent().await_postclick()

func tryOpen():
	if get_parent().has_status(StatusTypes.TERRITORY):
		var canContinue = false
		for box in get_adjacent_boxes(false, false):
			if box.open:
				canContinue = true
				break
		if canContinue:
			var canOpen = true
			for box in get_parent().rows[row]:
				if box.type == BoxTypes.ICE and box.customNum > 0 and !box.destroyed:
					canOpen = false
					break
			if canOpen:		
				innerOpen()
	else:
		var canOpen = true
		for box in get_parent().rows[row]:
			if box.type == BoxTypes.ICE and box.customNum > 0 and !box.destroyed:
				canOpen = false
				break
		if canOpen:	
			innerOpen()

func _on_button_button_up() -> void:
	if get_parent().gameRunning && !get_parent().awaiting_post_click:
		if get_parent().has_status(StatusTypes.DEMOLISH):
			var owned = get_parent()
			get_parent().destroy_box(self)
			owned.change_status_amount(StatusTypes.DEMOLISH, -1)
		else:
			if get_parent().has_status(StatusTypes.TRANSMOG) and revealed:
				var valids = []
				for newType in BoxTypes.MAX:
					if newType != type:
						valids.append(newType)
				var typeToAdd = valids.pick_random()
				loadType(typeToAdd)
				get_parent().change_status_amount(StatusTypes.TRANSMOG, -1)
			else:
				if !open:
					if get_parent().has_status(StatusTypes.SAFETY):
						if not revealed:
							revealBox()
							get_parent().change_status_amount(StatusTypes.SAFETY, -1)
						else:
							tryOpen()
					else:
						tryOpen()
				else:
					if get_parent().has_status(StatusTypes.CLOSENEXT) and type != BoxTypes.CLOSENEXT:
						closeBox()
						get_parent().change_status_amount(StatusTypes.CLOSENEXT, -1)
					else:
						on_self_clicked()

func close_random_other():
	var valids = []
	for box in get_parent().boxes:
		if box.open and box != self and !box.destroyed:
			valids.append(box)
	if valids.size() > 0:
		var toClose = valids.pick_random()
		toClose.closeBox()

func lg(text):
	get_parent().logToLog($Sprite2D.texture, text)
