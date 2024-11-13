extends Control

var id: String
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
var origPosX
var origPosY
var starScene = preload("res://vfx/vfxStar.tscn")
var flyingBoxScene = preload("res://vfx/vfxFlyingBoxImitator.tscn")

func _init() -> void:
	id = get_class().to_lower()
	nameText = tr_local("name")
	tooltip_text = tr_local("desc")

func tr_local(key: String) -> String:
	return tr("box." + id + "." + key)

func set_custom_num(val):
	customNum = val
	$Number.visible = true
	$Number.text = str(val)

func hide_custom_num():
	$Number.visible = false
	customNum = -1
	$Number.text = "15"

func destroyBox():
	if type == BoxTypes.BoxType.BEDROCK and open:
		pass
	else:
		main().play_sfx(SFXTypes.DESTROY)
		destroyed = true
		visible = false
		hide_custom_num()
		if type == BoxTypes.BoxType.EGG and open:
			lg("The Egg has hatched!")
			main().win()
		elif type == BoxTypes.BoxType.WORLDBEARER and open:
			lg("The Worldbearer has fallen!")
			main().lose()
		for box in main().boxes:
			if box.type == BoxTypes.BoxType.FLYING and box.open and !box.destroyed:
				var replacement = flyingBoxScene.instantiate()
				replacement.loadFromBox(self)
				main().addVfx(replacement)
				

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
	if new_type != type:
		if revealed:
			main().play_sfx(SFXTypes.TRANSMOG)
		hide_custom_num()
		var oldType = type
		type = new_type
		load_img()
		if open and oldType == BoxTypes.BoxType.BUTTERFLY:
			lg("The Butterfly has evolved!")
			main().win()

func load_img():
	revealedImg = load("res://boxImgs/"+id+".ng")
	match type:
		BoxTypes.BoxType.WINNER:
			revealedImg = load("res://boxImgs/WINNER.png")
		BoxTypes.BoxType.LOSS:
			revealedImg = load("res://boxImgs/LOSS.png")
		BoxTypes.BoxType.EMPTY:
			revealedImg = load("res://boxImgs/EMPTY.png")
		BoxTypes.BoxType.REVEAL_RANDOM:
			revealedImg = load("res://boxImgs/REVEAL_RANDOM.png")
		BoxTypes.BoxType.REVEAL_ROW:
			revealedImg = load("res://boxImgs/REVEAL_ROW.png")
		BoxTypes.BoxType.ONE_GOLD:
			revealedImg = load("res://boxImgs/ONE_GOLD.png")
		BoxTypes.BoxType.POISON:
			revealedImg = load("res://boxImgs/POISON.png")
		BoxTypes.BoxType.ANTIDOTE:
			revealedImg = load("res://boxImgs/ANTIDOTE.png")
		BoxTypes.BoxType.EXPLODING:
			revealedImg = load("res://boxImgs/EXPLODING.png")
		BoxTypes.BoxType.PAY_FOR_REVEALS:
			revealedImg = load("res://boxImgs/PAY_FOR_REVEALS.png")
		BoxTypes.BoxType.SHADOW:
			revealedImg = load("res://boxImgs/boxShadow.png")
		BoxTypes.BoxType.SAFETY:
			revealedImg = load("res://boxImgs/boxSafety.png")
		BoxTypes.BoxType.STAR:
			revealedImg = load("res://boxImgs/boxStar.png")
		BoxTypes.BoxType.TWO_GOLD:
			revealedImg = load("res://boxImgs/boxTwoDollars.png")
		BoxTypes.BoxType.JUMPSCARE:
			revealedImg = load("res://boxImgs/boxJumpscare.png")
		BoxTypes.BoxType.DRAGON:
			revealedImg = load("res://boxImgs/boxDragon.png")
		BoxTypes.BoxType.SPEND_TO_WIN:
			revealedImg = load("res://boxImgs/boxCrown.png")
		BoxTypes.BoxType.REVEAL_CORNERS:
			revealedImg = load("res://boxImgs/boxRevealCorners.png")
		BoxTypes.BoxType.SWORD:
			revealedImg = load("res://boxImgs/boxSword.png")
		BoxTypes.BoxType.THREE_GOLD:
			revealedImg = load("res://boxImgs/boxThreeGold.png")
		BoxTypes.BoxType.FIRE:
			revealedImg = load("res://boxImgs/boxFire.png")
		BoxTypes.BoxType.THREE_D:
			revealedImg = load("res://boxImgs/box3D.png")
		BoxTypes.BoxType.BOOKS:
			revealedImg = load("res://boxImgs/boxBooks.png")
		BoxTypes.BoxType.CLOCK:
			revealedImg = load("res://boxImgs/boxClock.png")
		BoxTypes.BoxType.GHOST:
			revealedImg = load("res://boxImgs/boxGhost.png")
		BoxTypes.BoxType.POVERTY:
			revealedImg = load("res://boxImgs/boxPoverty.png")
		BoxTypes.BoxType.SACRIFICE:
			revealedImg = load("res://boxImgs/boxSacrifice.png")
		BoxTypes.BoxType.CLOSE_ADJACENT:
			revealedImg = load("res://boxImgs/boxCloseAdjacent.png")
		BoxTypes.BoxType.INCOME:
			revealedImg = load("res://boxImgs/boxIncome.png")
		BoxTypes.BoxType.BOSS:
			revealedImg = load("res://boxImgs/boxBoss.png")
		BoxTypes.BoxType.SHY:
			revealedImg = load("res://boxImgs/boxShy.png")
		BoxTypes.BoxType.MIMIC:
			revealedImg = load("res://boxImgs/boxMimic.png")
		BoxTypes.BoxType.CURSE:
			revealedImg = load("res://boxImgs/boxCurse.png")
		BoxTypes.BoxType.PAY_FOR_SHIELD:
			revealedImg = load("res://boxImgs/boxSpendForShield.png")
		BoxTypes.BoxType.HEART:
			revealedImg = load("res://boxImgs/boxHeart.png")
		BoxTypes.BoxType.MUSIC:
			revealedImg = load("res://boxImgs/boxMusic.png")
		BoxTypes.BoxType.SUS:
			revealedImg = load("res://boxImgs/boxSus.png")
		BoxTypes.BoxType.SPEEDRUN:
			revealedImg = load("res://boxImgs/boxSpeedrun.png")
		BoxTypes.BoxType.DEMOLITION:
			revealedImg = load("res://boxImgs/boxWrecker.png")
		BoxTypes.BoxType.HEARTBREAK:
			revealedImg = load("res://boxImgs/boxHeartbreak.png")
		BoxTypes.BoxType.ROWBOMB:
			revealedImg = load("res://boxImgs/boxRowbomb.png")
		BoxTypes.BoxType.CLOSENEXT:
			revealedImg = load("res://boxImgs/boxCloser.png")
		BoxTypes.BoxType.AUTOOPEN:
			revealedImg = load("res://boxImgs/boxAutoOpen.png")
		BoxTypes.BoxType.ROWWIN:
			revealedImg = load("res://boxImgs/boxHorizWin.png")
		BoxTypes.BoxType.TEACHER:
			revealedImg = load("res://boxImgs/boxBigBrain.png")
		BoxTypes.BoxType.ARMAGEDDON:
			revealedImg = load("res://boxImgs/boxArmageddon.png")
		BoxTypes.BoxType.BEDROCK:
			revealedImg = load("res://boxImgs/boxBedrock.png")
		BoxTypes.BoxType.CLOAK:
			revealedImg = load("res://boxImgs/boxCloak.png")
		BoxTypes.BoxType.DESERT:
			revealedImg = load("res://boxImgs/boxDesert.png")
		BoxTypes.BoxType.FAIRY:
			revealedImg = load("res://boxImgs/boxFairy.png")
		BoxTypes.BoxType.HAT:
			revealedImg = load("res://boxImgs/boxHat.png")
		BoxTypes.BoxType.INVERT:
			revealedImg = load("res://boxImgs/boxInversion.png")
		BoxTypes.BoxType.SELFDESTRUCT:
			revealedImg = load("res://boxImgs/boxSelfDestruct.png")
		BoxTypes.BoxType.WAND:
			revealedImg = load("res://boxImgs/boxWand.png")
		BoxTypes.BoxType.INSTAOPEN:
			revealedImg = load("res://boxImgs/boxInstaOpen.png")
		BoxTypes.BoxType.BLACKJACK:
			revealedImg = load("res://boxImgs/blackjackBox.png")
		BoxTypes.BoxType.EGG:
			revealedImg = load("res://boxImgs/eggBox.png")
		BoxTypes.BoxType.INFERNO:
			revealedImg = load("res://boxImgs/infernoBox.png")
		BoxTypes.BoxType.KEY:
			revealedImg = load("res://boxImgs/keyBox.png")
		BoxTypes.BoxType.LOCK:
			revealedImg = load("res://boxImgs/lockBox.png")
		BoxTypes.BoxType.MATCH:
			revealedImg = load("res://boxImgs/matchBox.png")
		BoxTypes.BoxType.PANDORAS:
			revealedImg = load("res://boxImgs/pandorasBox.png")
		BoxTypes.BoxType.REVIVAL:
			revealedImg = load("res://boxImgs/revivalBox.png")
		BoxTypes.BoxType.SMARTBOMB:
			revealedImg = load("res://boxImgs/smartBombBox.png")
		BoxTypes.BoxType.TERRITORY:
			revealedImg = load("res://boxImgs/territoryBox.png")
		BoxTypes.BoxType.WORLDBEARER:
			revealedImg = load("res://boxImgs/worldbearerBox.png")
		BoxTypes.BoxType.PRINCESS:
			revealedImg = load("res://boxImgs/princessBox.png")
		BoxTypes.BoxType.MINE:
			revealedImg = load("res://boxImgs/mineBox.png")
		BoxTypes.BoxType.CLONE:
			revealedImg = load("res://boxImgs/clonerBox.png")
		BoxTypes.BoxType.GAMER:
			revealedImg = load("res://boxImgs/boxGamer.png")
		BoxTypes.BoxType.MAGNIFYING:
			revealedImg = load("res://boxImgs/magnifyingBox.png")
		BoxTypes.BoxType.VIRUS:
			revealedImg = load("res://boxImgs/viralBox.png")
		BoxTypes.BoxType.STARVE:
			revealedImg = load("res://boxImgs/starvingBox.png")
		BoxTypes.BoxType.SPIRE:
			revealedImg = load("res://boxImgs/boxAscended.png")
		BoxTypes.BoxType.CRUMBLING:
			revealedImg = load("res://boxImgs/boxCrumbling.png")
		BoxTypes.BoxType.TRIPLEPLAY:
			revealedImg = load("res://boxImgs/boxRunicThree.png")
		BoxTypes.BoxType.FOOD:
			revealedImg = load("res://boxImgs/foodBox.png")
		BoxTypes.BoxType.ALLSEEINGEYE:
			revealedImg = load("res://boxImgs/boxAllSeeingEye.png")
		BoxTypes.BoxType.WATERFALL:
			revealedImg = load("res://boxImgs/boxWaterfall.png")
		BoxTypes.BoxType.METEOR:
			revealedImg = load("res://boxImgs/boxMeteors.png")
		BoxTypes.BoxType.DAREDEVIL:
			revealedImg = load("res://boxImgs/daredevilBox.png")
		BoxTypes.BoxType.PAINT:
			revealedImg = load("res://boxImgs/boxPaint.png")
		BoxTypes.BoxType.ICE:
			revealedImg = load("res://boxImgs/boxIce.png")
		BoxTypes.BoxType.BULLSEYE:
			revealedImg = load("res://boxImgs/bullseyeBox.png")
		BoxTypes.BoxType.CONFIDENTIAL:
			revealedImg = load("res://boxImgs/classifiedBox.png")
		BoxTypes.BoxType.FISHING_ROD:
			revealedImg = load("res://boxImgs/fishingBox.png")
		BoxTypes.BoxType.IMPATIENT:
			revealedImg = load("res://boxImgs/impatientBox.png")
		BoxTypes.BoxType.TRANSMOG:
			revealedImg = load("res://boxImgs/alchemyBox.png")
		BoxTypes.BoxType.STUCK:
			revealedImg = load("res://boxImgs/stuckBox.png")
		BoxTypes.BoxType.FISH:
			revealedImg = load("res://boxImgs/fishBox.png")
		BoxTypes.BoxType.DNA:
			revealedImg = load("res://boxImgs/boxDNA.png")
		BoxTypes.BoxType.GUARDIAN:
			revealedImg = load("res://boxImgs/box1Up.png")
		BoxTypes.BoxType.PAINTTWO:
			revealedImg = load("res://boxImgs/boxBackground.png")
		BoxTypes.BoxType.MOON:
			revealedImg = load("res://boxImgs/boxMoon.png")
		BoxTypes.BoxType.BUTTERFLY:
			revealedImg = load("res://boxImgs/boxButterfly.png")
		BoxTypes.BoxType.MAP:
			revealedImg = load("res://boxImgs/boxMap.png")
		BoxTypes.BoxType.TREASURE:
			revealedImg = load("res://boxImgs/boxXMarksSpot.png")
		BoxTypes.BoxType.CHECKBOX:
			revealedImg = load("res://boxImgs/boxCheck.png")
		BoxTypes.BoxType.STELLAR:
			revealedImg = load("res://boxImgs/boxStarry.png")
		BoxTypes.BoxType.FLYING:
			revealedImg = load("res://boxImgs/boxFlying.png")
		BoxTypes.BoxType.UNDERWORLD:
			revealedImg = load("res://boxImgs/boxUnderworld.png")
		BoxTypes.BoxType.PROGRAM:
			revealedImg = load("res://boxImgs/boxProgram.png")
		BoxTypes.BoxType.SLEEPY:
			revealedImg = load("res://boxImgs/boxSleepy.png")
		BoxTypes.BoxType.EXP:
			revealedImg = load("res://boxImgs/boxRPG.png")
		BoxTypes.BoxType.IVY:
			revealedImg = load("res://boxImgs/boxIvy.png")
		
	if revealed:
		$Sprite2D.texture = revealedImg

func revealBox():
	if !destroyed:
		var was_already_revealed = revealed
		revealed = true
		if type == BoxTypes.BoxType.MIMIC and not open:
			if special == -1:
				var replacement = BoxTypes.BoxType.MIMIC
				while replacement == BoxTypes.BoxType.MIMIC:
					replacement = main().rng.randi_range(0, main().unlockedBoxes - 1)
					special = replacement
			type = special

			load_img()
			load_text()
			$Sprite2D.texture = revealedImg
			type = BoxTypes.BoxType.MIMIC
		else:
			$Sprite2D.texture = revealedImg
		if !open:
			$Outline.texture = load("res://boxImgs/outlineRevealed.png")
		if !was_already_revealed:
			$Sprite2D.modulate = Color(0.8, 0.8, 0.8, 1)
			main().play_sfx(SFXTypes.REVEAL)
			lg(nameText + " was revealed!")
			var willOpen = false
			for box in main().rows[row]:
				if box.type == BoxTypes.BoxType.IMPATIENT and !box.destroyed and box.open:
					willOpen = true
			if willOpen:
				main().logToLog(null, "Impatient Box opens the revealed box!")
				openBox()

func openBox():
	if !destroyed and !open:
		main().play_sfx(SFXTypes.OPEN)
		var wasRevealed = revealed
		revealed = true
		just_opened = true
		open = true
		$Outline.texture = load("res://boxImgs/outlineClicked.png")
		load_img()
		$Sprite2D.modulate = Color(1, 1, 1, 1)
		lg("Opened " + nameText)
		activateEffects()
		if !wasRevealed:
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.CHECKBOX and box.open and !box.destroyed and !box.just_opened:
					get_parent().reveal_random()
				if box.type == BoxTypes.BoxType.EXP and box.open and box.customNum > 0 and !box.just_opened:
					box.set_custom_num(box.customNum-1)
					if box.customNum == 0:
						main().win()
						if main().gameRunning:
							box.hide_custom_num()
		for box in main().boxes:
			if box.type == BoxTypes.BoxType.STELLAR and box.open and !box.destroyed and !box.just_opened:
				for i in 3:
					var newStar = starScene.instantiate()
					newStar.global_position.x = global_position.x
					newStar.global_position.y = global_position.y
					main().addVfx(newStar)

func closeBox():
	if open:
		$Sprite2D.modulate = Color(0.8, 0.8, 0.8, 1)
		main().play_sfx(SFXTypes.CLOSE)
		lg(nameText + " was closed.")
		open = false
		if type != BoxTypes.BoxType.TRIPLEPLAY:
			hide_custom_num()
		$Outline.texture = load("res://boxImgs/outlineRevealed.png")

func activateEffects():
	match type:
		BoxTypes.BoxType.WINNER:
			main().win()
		BoxTypes.BoxType.LOSS:
			main().lose()
		BoxTypes.BoxType.EMPTY:
			pass
		BoxTypes.BoxType.REVEAL_RANDOM:
			main().reveal_random()
		BoxTypes.BoxType.REVEAL_ROW:
			main().reveal_row(row)
		BoxTypes.BoxType.ONE_GOLD:
			main().add_status(StatusTypes.GOLD, 1)
		BoxTypes.BoxType.POISON:
			main().add_status(StatusTypes.POISON, 8)
		BoxTypes.BoxType.ANTIDOTE:
			if (main().has_status(StatusTypes.POISON)):
				main().remove_status(StatusTypes.POISON)
			for box in get_adjacent_boxes(false, false):
				if box.open and box.type == BoxTypes.BoxType.VIRUS:
					main().win()
		BoxTypes.BoxType.JUMPSCARE:
			if main().opens == 0:
				main().lose()
		BoxTypes.BoxType.SAFETY:
			main().add_status(StatusTypes.SAFETY, 1)
		BoxTypes.BoxType.SHADOW:
			close_random_other()
		BoxTypes.BoxType.TWO_GOLD:
			main().add_status(StatusTypes.GOLD, 2)
		BoxTypes.BoxType.STAR:
			var adjacents = get_adjacent_boxes(false, false)
			var winning = true
			for box in adjacents:
				if !box.open:
					winning = false
			if winning:
				main().win()
		BoxTypes.BoxType.REVEAL_CORNERS:
			main().reveal_corners()
		BoxTypes.BoxType.DRAGON:
			var winning = false
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.SWORD and box.open and !box.destroyed:
					winning = true
			if winning:
				main().win()
			else:
				main().lose()
		BoxTypes.BoxType.SWORD:
			pass
		BoxTypes.BoxType.THREE_GOLD:
			main().add_status(StatusTypes.GOLD, 3)
		BoxTypes.BoxType.SPEND_TO_WIN:
			pass
		BoxTypes.BoxType.FIRE:
			var toChange = get_adjacent_boxes(false, true)
			var result = []
			for box in toChange:
				if box.type != BoxTypes.BoxType.FIRE:
					result.append(box)
			if result.size() > 0:
				var toHit = result.pick_random()
				toHit.loadType(BoxTypes.BoxType.FIRE)
		BoxTypes.BoxType.GHOST:
			for i in 2:
				var valids = []
				for box in main().boxes:
					if !box.destroyed and box != self:
						valids.append(box)
				var toChange = valids.pick_random()
				toChange.loadType(BoxTypes.BoxType.LOSS)
		BoxTypes.BoxType.CLOCK:
			set_custom_num(20)
			fNum = 1
		BoxTypes.BoxType.BOOKS:
			var count = 0
			for box in main().boxes:
				if box.open and !box.destroyed:
					count += 1
			if count >= 11:
				main().win()
		BoxTypes.BoxType.SACRIFICE:
			set_custom_num(5)
		BoxTypes.BoxType.POVERTY:
			if (main().has_status(StatusTypes.GOLD)):
				main().remove_status(StatusTypes.GOLD)
		BoxTypes.BoxType.CLOSE_ADJACENT:
			for box in get_adjacent_boxes(false, false):
				if box.open:
					box.closeBox()
		BoxTypes.BoxType.THREE_D:
			for i in 3:
				main().reveal_random()
		BoxTypes.BoxType.INCOME:
			pass
		BoxTypes.BoxType.BOSS:
			set_custom_num(12)
		BoxTypes.BoxType.SHY:
			pass
		BoxTypes.BoxType.MIMIC:
			if main().rng.randi_range(0, 2) == 2:
				main().lose()
		BoxTypes.BoxType.CURSE:
			main().add_status(StatusTypes.CURSE, 1)
		BoxTypes.BoxType.PAY_FOR_SHIELD:
			pass
		BoxTypes.BoxType.HEART:
			main().add_status(StatusTypes.HEART, 3)
		BoxTypes.BoxType.MUSIC:
			main().get_node("MusicPlayer").play()
			pass
		BoxTypes.BoxType.METEOR:
			for box in get_adjacent_boxes(false, false):
				if box.type == BoxTypes.BoxType.BEDROCK and box.open:
					main().win()
		BoxTypes.BoxType.SUS:
			for i in 2:
				var list = []
				for box in main().boxes:
					if box.type != BoxTypes.BoxType.MIMIC and !box.destroyed:
						list.append(box)
				var toChange = list.pick_random()
				var oldType = toChange.type
				toChange.loadType(BoxTypes.BoxType.MIMIC)
				toChange.special = oldType
				if toChange.revealed and not toChange.open:
					toChange.revealBox()
		BoxTypes.BoxType.SPEEDRUN:
			if main().opens == 0:
				main().win()
		BoxTypes.BoxType.DEMOLITION:
			main().add_status(StatusTypes.DEMOLISH, 1)
		BoxTypes.BoxType.CLOSENEXT:
			main().add_status(StatusTypes.CLOSENEXT, 1)
		BoxTypes.BoxType.ROWWIN:
			var willWin = true
			for box in main().rows[row]:
				if !box.open and !box.destroyed:
					willWin = false
			if willWin:
				main().win()
		BoxTypes.BoxType.ARMAGEDDON:
			set_custom_num(3)
			lg("3 opens to Armageddon!")
		BoxTypes.BoxType.CLOAK:
			var hasWand = false
			var hasHat = false
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.WAND and !box.destroyed and box.open:
					hasWand = true
				if box.type == BoxTypes.BoxType.HAT and !box.destroyed and box.open:
					hasHat = true
			if hasWand and hasHat:
				main().win()
		BoxTypes.BoxType.DESERT:
			var count = 0
			for box in main().boxes:
				if box.destroyed:
					count += 1
			if count >= 11:
				main().win()
		BoxTypes.BoxType.FAIRY:
			var valids = []
			for box in main().boxes:
				if !box.destroyed and !box.revealed and box.type != BoxTypes.BoxType.FAIRY:
					valids.append(box)
			if valids.size() > 0:
				var toChange = valids.pick_random()
				toChange.loadType(BoxTypes.BoxType.FAIRY)
			var count = 0
			for box in main().boxes:
				if box.open and !box.destroyed and box.type == BoxTypes.BoxType.FAIRY:
					count += 1
			if count >= 4:
				main().win()
		BoxTypes.BoxType.HAT:
			var hasWand = false
			var hasCloak = false
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.WAND and !box.destroyed and box.open:
					hasWand = true
				if box.type == BoxTypes.BoxType.CLOAK and !box.destroyed and box.open:
					hasCloak = true
			if hasWand and hasCloak:
				main().win()
		BoxTypes.BoxType.INVERT:
			if main().has_status(StatusTypes.INVERSION):
				main().remove_status(StatusTypes.INVERSION)
			else:
				main().add_status(StatusTypes.INVERSION, 1)
		BoxTypes.BoxType.WAND:
			var hasHat = false
			var hasCloak = false
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.HAT and !box.destroyed and box.open:
					hasHat = true
				if box.type == BoxTypes.BoxType.CLOAK and !box.destroyed and box.open:
					hasCloak = true
			if hasHat and hasCloak:
				main().win()
		BoxTypes.BoxType.INSTAOPEN:
			var myRow = main().rows[row]
			if col != 0:
				myRow[col-1].openBox()
			if col < myRow.size() - 1:
				myRow[col+1].openBox()
		BoxTypes.BoxType.BLACKJACK:
			var count = 0
			for box in main().boxes:
				if !box.destroyed and box.open:
					count += 1
			if count == 21:
				main().win()
			elif count > 21:
				main().lose()
		BoxTypes.BoxType.KEY:
			main().add_status(StatusTypes.KEY, 1)
		BoxTypes.BoxType.LOCK:
			if main().has_status(StatusTypes.KEY):
				main().win()
		BoxTypes.BoxType.MATCH:
			var list = []
			for box in main().boxes:
				if box.type != BoxTypes.BoxType.FIRE and !box.destroyed:
					list.append(box)
			var toChange = list.pick_random()
			toChange.loadType(BoxTypes.BoxType.FIRE)
			if toChange.revealed:
				toChange.revealBox()
		BoxTypes.BoxType.PANDORAS:
			for box in main().boxes:
				if box != self and box.revealed and not box.destroyed:
					box.loadType(BoxTypes.BoxType.LOSS)
		BoxTypes.BoxType.REVIVAL:
			var valids = []
			for box in main().boxes:
				if box.destroyed:
					valids.append(box)
			var siz = valids.size()
			for i in min(5, siz):
				var toRes = valids.pick_random()
				toRes.reviveBox()
				valids.erase(toRes)
		BoxTypes.BoxType.SMARTBOMB:
			for box in get_adjacent_boxes(true, false):
				box.revealBox()
		BoxTypes.BoxType.TERRITORY:
			main().add_status(StatusTypes.TERRITORY, 4)
		BoxTypes.BoxType.PRINCESS:
			var willDie = false
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.DRAGON and box.revealed and not box.destroyed:
					willDie = true
			if willDie:
				main().lose()
			else:
				main().add_status(StatusTypes.GOLD, 3)
		BoxTypes.BoxType.CLONE:
			set_custom_num(3)
		BoxTypes.BoxType.GAMER:
			if main().winstreak > 0:
				main().win()
		BoxTypes.BoxType.STARVE:
			for i in 5:
				var list = []
				for box in main().boxes:
					if box.type != BoxTypes.BoxType.FOOD and !box.destroyed and !box.revealed:
						list.append(box)
				if list.size() > 0:
					var toChange = list.pick_random()
					toChange.loadType(BoxTypes.BoxType.FOOD)
			set_custom_num(6)
		BoxTypes.BoxType.FOOD:
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.STARVE and box.open:
					box.set_custom_num(6)
					box.just_opened = true
		BoxTypes.BoxType.SPIRE:
			var willActivate = true
			for badge in main().get_node("BadgeList").get_children():
				if badge.enabled:
					willActivate = false
			if willActivate:
				for box in main().boxes: 
					if box.type == BoxTypes.BoxType.EMPTY and !box.destroyed:
						box.loadType(BoxTypes.BoxType.WINNER)
		BoxTypes.BoxType.TRIPLEPLAY:
			if customNum == -1:
				set_custom_num(1)
			else:
				set_custom_num(customNum + 1)
				if customNum == 3:
					main().win()
		BoxTypes.BoxType.ALLSEEINGEYE:
			for i in 10:
				main().reveal_random()
			set_custom_num(3)
		BoxTypes.BoxType.WATERFALL:
			if row == main().unlockedRows - 1:
				main().win()
			else:
				var valids = []
				for box in main().rows[row+1]:
					if !box.destroyed:
						valids.append(box)
				if valids.size() > 0:
					var toChange = valids.pick_random()
					toChange.loadType(BoxTypes.BoxType.WATERFALL)
		BoxTypes.BoxType.PAINT:
			var result = Color(main().rng.randf_range(0, 1), main().rng.randf_range(0, 1), main().rng.randf_range(0, 1), 1)
			main().get_node("ColorRect").color = result
		BoxTypes.BoxType.ICE:
			set_custom_num(3)
		BoxTypes.BoxType.BULLSEYE:
			var will_reveal = true
			for box in get_adjacent_boxes(false, false):
				if box.revealed:
					will_reveal = false
					break
			if will_reveal:
				for box in get_adjacent_boxes(true, true):
					box.revealBox()
		BoxTypes.BoxType.CONFIDENTIAL:
			var count = 0
			for box in main().boxes:
				if box.revealed and not box.destroyed:
					count += 1
			if count >= 18:
				lg("Espionage victory!")
				main().win()
		BoxTypes.BoxType.FISHING_ROD:
			for i in 3:
				var list = []
				for box in main().boxes:
					if box.type != BoxTypes.BoxType.FISH and !box.destroyed and !box.revealed:
						list.append(box)
				if list.size() > 0:
					var toChange = list.pick_random()
					toChange.loadType(BoxTypes.BoxType.FISH)
		BoxTypes.BoxType.TRANSMOG:
			main().add_status(StatusTypes.TRANSMOG, 2)
		BoxTypes.BoxType.FISH:
			var count = 0
			for box in main().boxes:
				if box.open and !box.destroyed and box.type == BoxTypes.BoxType.FISH:
					count += 1
			if count >= 3:
				main().win()
		BoxTypes.BoxType.DNA:
			var revealAllAdjacent = false
			var newType = main().rng.randi_range(0, BoxTypes.BoxType.MAX-1)
			for box in get_adjacent_boxes(false, false):
				if box.type != newType:
					box.loadType(newType)
					if box.revealed:
						revealAllAdjacent = true
			if revealAllAdjacent:
				for box in get_adjacent_boxes(true, false):
					box.revealBox()
		BoxTypes.BoxType.PAINTTWO:
			for box in main().boxes:
				if !box.open and !box.destroyed and !box.revealed:
					box.get_node("Sprite2D").modulate = Color(main().rng.randf_range(0, 1), main().rng.randf_range(0, 1), main().rng.randf_range(0, 1), 1)
		BoxTypes.BoxType.MAP:
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.TREASURE && !box.destroyed:
					box.revealBox()
		BoxTypes.BoxType.TREASURE:
			var willWin = false
			var seen = []
			var stack = []
			stack.push_front(self)
			while stack.size() > 0:
				var cur = stack.pop_front()
				if !seen.has(cur):
					seen.append(cur)
					for box in cur.get_adjacent_boxes(false, false):
						if !box.destroyed and box.open:
							if box.type == BoxTypes.BoxType.MAP:
								willWin = true
								break
							else:
								stack.push_front(box)
			if willWin:
				main().win()
		BoxTypes.BoxType.UNDERWORLD:
			main().lose()
			if main().gameRunning:
				main().win()
		BoxTypes.BoxType.SLEEPY:
			for box in main().boxes:
				if !box.destroyed and (box.type == BoxTypes.BoxType.WINNER || box.type == BoxTypes.BoxType.LOSS):
					box.destroyBox()
		BoxTypes.BoxType.EXP:
			set_custom_num(9)
		BoxTypes.BoxType.IVY:
			if row > 0:
				var result = []
				var rowAbove = main().rows[row-1]
				if col != 0:
					result.append(rowAbove[col - 1])
				if rowAbove.size() > col:
					result.append(rowAbove[col])
				for box in result:
					if !box.destroyed:
						box.loadType(BoxTypes.BoxType.IVY)

func updateTooltipForMe():
	var curName = "Unknown Box"
	var curStatus = "Closed"
	var curDesc = "What could be inside?"
	if revealed:
		if type == BoxTypes.BoxType.MIMIC and special != -1 and revealed and not open:
			type = special
			load_text()
			curName = nameText
			curStatus = "Revealed"
			curDesc = tooltipText
			type = BoxTypes.BoxType.MIMIC
			load_text()
		else:
			curName = nameText
			if open:
				curStatus = "Opened"
			else:
				curStatus = "Revealed"
			curDesc = tooltipText
	main().get_node("Tooltip").setup(curName, curStatus, curDesc)

var cursorTransmog = load("res://cursorTransmog.png")
var cursorDestroy = load("res://cursorDestroy.png")
var cursorClose = load("res://cursorClose.png")
var cursorReveal = load("res://cursorReveal.png")
var cursorUse = load("res://cursorUse.png")
var cursorNo = load("res://cursorNo.png")
var cursorOpen = load("res://cursorOpen.png")
var cursorNormal = load("res://cursorNormal.png")

func updateCursorForMe():
	if !Input.is_action_pressed("pan"):
		var normCursor = true
		if !destroyed:
			if main().has_status(StatusTypes.DEMOLISH):
				normCursor = false
				Input.set_custom_mouse_cursor(cursorDestroy)
			else:
				if revealed and main().has_status(StatusTypes.TRANSMOG):
					normCursor = false
					Input.set_custom_mouse_cursor(cursorTransmog)
				else:
					if !open:
						if main().has_status(StatusTypes.SAFETY) and !revealed:
							normCursor = false
							Input.set_custom_mouse_cursor(cursorReveal)
					else:
						if main().has_status(StatusTypes.CLOSENEXT) and type != BoxTypes.BoxType.CLOSENEXT:
							normCursor = false
							Input.set_custom_mouse_cursor(cursorClose)
						elif canUse():
							normCursor = false
							Input.set_custom_mouse_cursor(cursorUse)
		if normCursor:
			if !destroyed and !open:
				if canOpen():
					Input.set_custom_mouse_cursor(cursorOpen)
				else:
					Input.set_custom_mouse_cursor(cursorNo)
			else:
				Input.set_custom_mouse_cursor(cursorNormal)

func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	if mousePos.x >= global_position.x - 37.5 and mousePos.x <= global_position.x + 37.5 and mousePos.y >= global_position.y - 37.5 and mousePos.y <= global_position.y + 37.5:
		if !destroyed:
			updateTooltipForMe()
		if main().gameRunning:
			updateCursorForMe()
	if !destroyed:
		if open and main().gameRunning:
			match (type):
				BoxTypes.BoxType.CLOCK:
					fNum -= delta
					if fNum <= 0:
						fNum = 1
						if customNum > 0:
							if customNum == 1:
								lg("Time's up!")
								main().lose()
							set_custom_num(customNum-1)

func on_click():
	if open and not just_opened and not destroyed and main().gameRunning:
		match (type):
			BoxTypes.BoxType.MINE:
				for box in get_adjacent_boxes(false, false):
					if main().last_opened == box:
						lg("Mined some gold!")
						main().add_status(StatusTypes.GOLD, 1)
			BoxTypes.BoxType.EXPLODING:
				lg(nameText + " exploded!")
				for box in get_adjacent_boxes(false, false):
					main().destroy_box(box)
				main().destroy_box(self)
			BoxTypes.BoxType.INCOME:
				if main().rng.randi_range(0, 2) == 2:
					lg(nameText + " generated 1 Gold!")
					main().add_status(StatusTypes.GOLD, 1)
			BoxTypes.BoxType.SHY:
				if main().rng.randi_range(0, 2) == 2:
					closeBox()
			BoxTypes.BoxType.HEARTBREAK:
				if main().rng.randi_range(0, 9) == 9:
					lg(nameText + " activated - oh no!")
					main().lose()
			BoxTypes.BoxType.ROWBOMB:
				lg(nameText + " exploded!")
				for box in main().rows[row]:
					if box != self:
						main().destroy_box(box)
				main().destroy_box(self)
			BoxTypes.BoxType.AUTOOPEN:
				var valids = get_adjacent_boxes(false, true)
				if valids.size() > 0:
					lg(nameText + " is opening a box!")
					var toOpen = valids.pick_random()
					toOpen.openBox()
					toOpen.just_opened = true
			BoxTypes.BoxType.TEACHER:
				var valids = get_adjacent_boxes(true, false)
				if valids.size() > 0:
					lg(nameText + " activated!")
					var toReveal = valids.pick_random()
					toReveal.revealBox()
			BoxTypes.BoxType.SELFDESTRUCT:
				lg(nameText + " exploded!")
				main().destroy_box(self)
			BoxTypes.BoxType.ARMAGEDDON:
				if customNum == 1:
					lg("Armageddon has arrived!")
					main().clear_central()
					main().destroy_box(self)
				elif customNum > 0:
					set_custom_num(customNum - 1)
					lg(str(customNum) + " opens to Armageddon!")
			BoxTypes.BoxType.SMARTBOMB:
				lg(nameText + " exploded!")
				for box in get_adjacent_boxes(false, false):
					main().destroy_box(box)
				main().destroy_box(self)
			BoxTypes.BoxType.BOSS:
				if customNum > 0:
					if customNum == 1:
						lg("You slayed the Boss!")
						main().win()
					set_custom_num(customNum-1)
					if main().gameRunning and customNum == 0:
							hide_custom_num()
			BoxTypes.BoxType.CLONE:
				if customNum > 0:
					if customNum == 1:
						var found = main().rng.randi_range(0, BoxTypes.BoxType.MAX - 1)
						loadType(found)
						closeBox()
					else:
						set_custom_num(customNum - 1)
			BoxTypes.BoxType.VIRUS:
				if special != 1:
					for box in get_adjacent_boxes(false, false):
						if box.revealed and box.open and box.type != BoxTypes.BoxType.VIRUS:
							box.loadType(BoxTypes.BoxType.VIRUS)
							box.special = 1
			BoxTypes.BoxType.STARVE:
				if customNum > 0:
					if customNum == 1:
						lg("The Hungry Box starves!")
						main().lose()
					set_custom_num(customNum - 1)
					if main().gameRunning and customNum == 0:
							hide_custom_num()
			BoxTypes.BoxType.CRUMBLING:
				for box in main().boxes:
					if !box.destroyed:
						main().destroy_box(box)
						break
			BoxTypes.BoxType.ALLSEEINGEYE:
				if customNum > 0:
					if customNum == 1:
						lg("All Seeing Box activates!")
						main().lose()
					set_custom_num(customNum - 1)
					if main().gameRunning and customNum == 0:
							hide_custom_num()
			BoxTypes.BoxType.ICE:
				if customNum > 0:
					if customNum == 1:
						lg("Ice Box has thawed!")
					set_custom_num(customNum - 1)
					if customNum == 0:
							hide_custom_num()
			BoxTypes.BoxType.STUCK:
				# better later
				var willWin = true
				for box in main().boxes:
					if box.canClick():
						willWin = false
				if willWin:
					lg("You've softlocked! Softlock Box activates!")
					main().win()
	just_opened = false

func on_self_clicked():
	match (type):
		BoxTypes.BoxType.PAY_FOR_REVEALS:
			var valids = get_adjacent_boxes(true, false)
			if valids.size() > 0:
				if main().status_amount(StatusTypes.GOLD) > 0:
					main().play_sfx(SFXTypes.ACTIVATE)
					main().change_status_amount(StatusTypes.GOLD, -1)
					var toReveal = valids.pick_random()
					toReveal.revealBox()
		BoxTypes.BoxType.SPEND_TO_WIN:
			if main().status_amount(StatusTypes.GOLD) >= 6:
				main().play_sfx(SFXTypes.ACTIVATE)
				main().change_status_amount(StatusTypes.GOLD, -6)
				main().win()
		BoxTypes.BoxType.SACRIFICE:
			if customNum > 0:
				main().play_sfx(SFXTypes.ACTIVATE)
				var thingy = main()
				var toChange = thingy.get_random_box()
				main().destroy_box(toChange)
				thingy.reveal_random()
				set_custom_num(customNum - 1)
		BoxTypes.BoxType.PAY_FOR_SHIELD:
			if main().status_amount(StatusTypes.GOLD) >= 1:
				var valids = []
				for box in main().boxes:
					if !box.destroyed and box.open:
						valids.append(box)
				if valids.size() > 0:
					main().play_sfx(SFXTypes.ACTIVATE)
					main().change_status_amount(StatusTypes.GOLD, -1)
					var toClose = valids.pick_random()
					toClose.closeBox()
		BoxTypes.BoxType.INFERNO:
			var count = 0
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.FIRE and box.open:
					count += 1
			if count >= 10:
				main().play_sfx(SFXTypes.ACTIVATE)
				main().win()
		BoxTypes.BoxType.MAGNIFYING:
			if main().status_amount(StatusTypes.GOLD) >= 1:
				main().play_sfx(SFXTypes.ACTIVATE)
				main().change_status_amount(StatusTypes.GOLD, -1)
				main().reveal_random()
		BoxTypes.BoxType.DAREDEVIL:
			var result = main().rng.randi_range(0, 9)
			main().play_sfx(SFXTypes.ACTIVATE)
			if result <= 1:
				lg("Lucky! Daredevil Box made you win!")
				main().win()
			elif result <= 4:
				lg("Daredevil Box made you lose!")
				main().lose()
			else:
				lg("Daredevil Box didn't do anything!")
		BoxTypes.BoxType.MOON:
			for i in 5:
				var valids = []
				for box in main().boxes:
					if !box.destroyed and box.open and box != self:
						valids.append(box)
				if valids.size() > 0:
					main().play_sfx(SFXTypes.ACTIVATE)
					var toClose = valids.pick_random()
					toClose.closeBox()
			destroyBox()
			
	main().update_stat_texts()

func get_adjacent_boxes(notRevealed, notOpen):
	var result = []
	var myRow = main().rows[row]
	if col != 0:
		result.append(myRow[col - 1])
	if col < myRow.size() - 1:
		result.append(myRow[col+1])
	if row > 0:
		var rowAbove = main().rows[row-1]
		if col != 0:
			result.append(rowAbove[col - 1])
		if rowAbove.size() > col:
			result.append(rowAbove[col])
	if row < main().unlockedRows - 1:
		var rowBelow = main().rows[row+1]
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
	main().last_opened = self
	openBox()
	main().await_postclick()

func canOpen():
	var canOpen = true
	if main().has_status(StatusTypes.TERRITORY):
		canOpen = false
		for box in get_adjacent_boxes(false, false):
			if box.open:
				canOpen = true
				break
	for box in get_adjacent_boxes(false, false):
		if box.type == BoxTypes.BoxType.ICE and box.customNum > 0 and !box.destroyed and box.open:
			canOpen = false
	for box in main().boxes:
		if box.type == BoxTypes.BoxType.PROGRAM and box.open and !box.destroyed:
			for boxRow in main().rows:
				for other in boxRow:
					if !other.destroyed and !other.open:
						if other.row < row:
							canOpen = false
							break
	return canOpen

func canUse():
	match (type):
		BoxTypes.BoxType.PAY_FOR_REVEALS:
			var valids = get_adjacent_boxes(true, false)
			if valids.size() > 0:
				if main().status_amount(StatusTypes.GOLD) > 0:
					return true
			return false
		BoxTypes.BoxType.SPEND_TO_WIN:
			if main().status_amount(StatusTypes.GOLD) >= 6:
				return true
			return false
		BoxTypes.BoxType.SACRIFICE:
			if customNum > 0:
				return true
			return false
		BoxTypes.BoxType.PAY_FOR_SHIELD:
			if main().status_amount(StatusTypes.GOLD) >= 1:
				return true
			return false
		BoxTypes.BoxType.INFERNO:
			var count = 0
			for box in main().boxes:
				if box.type == BoxTypes.BoxType.FIRE and box.open:
					count += 1
			if count >= 10:
				return true
			return false
		BoxTypes.BoxType.MAGNIFYING:
			if main().status_amount(StatusTypes.GOLD) >= 1:
				return true
			return false
		BoxTypes.BoxType.DAREDEVIL:
			return true
		BoxTypes.BoxType.MOON:
			return true

func canClick():
	if main().has_status(StatusTypes.DEMOLISH):
		return true
	if main().has_status(StatusTypes.DEMOLISH) and revealed:
		return true
	if open:
		if main().has_status(StatusTypes.CLOSENEXT) and type != BoxTypes.BoxType.CLOSENEXT:
			return true
	return canOpen() or canUse()

func tryOpen():
	if canOpen():
		innerOpen()

func close_random_other():
	var valids = []
	for box in main().boxes:
		if box.open and box != self and !box.destroyed:
			valids.append(box)
	if valids.size() > 0:
		var toClose = valids.pick_random()
		toClose.closeBox()

func lg(text):
	main().logToLog($Sprite2D.texture, text)

func main():
	return get_parent()

func _on_button_pressed() -> void:
	if main().gameRunning && !main().awaiting_post_click:
		if main().has_status(StatusTypes.DEMOLISH):
			var owned = main()
			main().destroy_box(self)
			owned.change_status_amount(StatusTypes.DEMOLISH, -1)
		else:
			if main().has_status(StatusTypes.TRANSMOG) and revealed:
				var valids = []
				for newType in BoxTypes.BoxType.MAX:
					if newType != type:
						valids.append(newType)
				var typeToAdd = valids.pick_random()
				loadType(typeToAdd)
				main().change_status_amount(StatusTypes.TRANSMOG, -1)
			else:
				if !open:
					if main().has_status(StatusTypes.SAFETY):
						if not revealed:
							revealBox()
							main().change_status_amount(StatusTypes.SAFETY, -1)
						else:
							tryOpen()
					else:
						tryOpen()
				else:
					if main().has_status(StatusTypes.CLOSENEXT) and type != BoxTypes.BoxType.CLOSENEXT:
						closeBox()
						main().change_status_amount(StatusTypes.CLOSENEXT, -1)
					else:
						on_self_clicked()
	else:
		if !main().gameRunning:
			main().startGame()
