class_name Box extends Control

var id: String
var revealed = false
var just_opened = false
var open = false
var nameText = ""
var tooltipText = ""
var revealedImg
var row = -1
var col = -1
var destroyed = false
var customNum = -1
var origPosX
var origPosY
var was_revealed_when_opened: bool
static var main: Main
var arr = []
var fNum : float = 0
var special = 0
var heldStr = ""
static var alphabet = "abcdefghijklmnopqrstuvwxyz"

static var outlineClosed = preload("res://boxImgs/outlineClosed.png")
static var outlineOpen = preload("res://boxImgs/outlineClicked.png")
static var outlineRevealed = preload("res://boxImgs/outlineRevealed.png")
static var arrowImg = preload("res://uiImgs/arrow.png")
static var flyingBoxScene = preload("res://vfx/vfxFlyingBoxImitator.tscn")
static var smileyScene = load("res://vfx/vfxFallingSmiley.tscn")
static var starScene = preload("res://vfx/vfxStar.tscn")

var addedWidgets = []

func load_text() -> void:
	var text := load_box_text(id)
	nameText = text[0]
	tooltipText = text[1]

static func load_box_text(type: String) -> Array[String]:
	return [tr_box(type, "name"), tr_box(type, "desc")]

func load_img():
	revealedImg = get_box_img(id)
	show_img()

func show_img():
	if revealed:
		$Sprite2D.texture = revealedImg

static func get_box_img(type: String) -> Texture2D:
	return imgTable[type]

func tr_local(key: String) -> String:
	return tr_box(id, key)

static func tr_box(type: String, key: String) -> String:
	return main.tr("box." + type + "." + key)

func set_custom_num(val):
	customNum = val
	$Number.visible = true
	$Number.text = str(val)

func hide_custom_num():
	$Number.visible = false
	customNum = -1
	$Number.text = ""

func on_open() -> void:
	match id:
		"allseeingeye":
			for i in 10:
				main.reveal_random()
			set_custom_num(3)
		"alphabet":
			arr.clear()
		"antidote":
			for box in main.boxes:
				if box.id == "poison" and (box.open or box.revealed):
					box.destroyBox()
					main.modBoxStat(id, "destroys", 1)
			for box in get_adjacent_boxes(false, false):
				if box.open and box.id == "virus":
					win()
		"armageddon":
			set_custom_num(3)
			lg("3 opens to Armageddon!")
		"badgebox":
			if badgeEquipped("badgeboxup1"):
				for box in get_adjacent_boxes(true, false):
					box.revealBox()
			if badgeEquipped("badgeboxup2"):
				for box in get_adjacent_boxes(false, false):
					if box.open:
						box.closeBox()
			if badgeEquipped("badgeboxup3"):
				for i in 3:
					var valids = []
					for box in main.boxes:
						if !box.open and box.id != "badgebox":
							valids.append(box)
					if valids.size() > 0:
						valids.pick_random().loadType("badgebox")
		"blackjack":
			var count = 0
			for box in main.boxes:
				if !box.destroyed and box.open:
					count += 1
			if count == 21:
				win()
			elif count > 21:
				lose()
		"books":
			var count = 0
			for box in main.boxes:
				if box.open and !box.destroyed:
					count += 1
			if count >= 11:
				win()
		"boss":
			set_custom_num(13)
		"bullseye":
			var will_reveal = true
			for box in get_adjacent_boxes(false, false):
				if box.revealed:
					will_reveal = false
					break
			if will_reveal:
				modStat("timesActivated", 1)
				for box in get_adjacent_boxes(true, true):
					box.revealBox()
		"cloak":
			var hasWand = false
			var hasHat = false
			for box in main.boxes:
				if box.id == "wand" and !box.destroyed and box.open:
					hasWand = true
				if box.id == "hat" and !box.destroyed and box.open:
					hasHat = true
			if hasWand and hasHat:
				win()
		"clock":
			set_custom_num(20)
			fNum = 1
		"clone":
			set_custom_num(3)
		"closeadjacent":
			for box in get_adjacent_boxes(false, false):
				if box.open:
					modStat("timesActivated", 1)
					box.closeBox()
		"closenext":
			main.add_status(StatusTypes.CLOSENEXT, 1)
		"compass":
			for box in main.boxes:
				if box.id == "winner" and !box.destroyed:
					var newArrow = TextureRect.new();
					newArrow.texture = arrowImg
					newArrow.size = Vector2(44, 44)
					newArrow.pivot_offset = Vector2(22, 22)
					newArrow.anchor_left = 0.5
					newArrow.anchor_right = 0.5
					newArrow.anchor_top = 0.5
					newArrow.anchor_bottom = 0.5
					newArrow.offset_left = -22
					newArrow.offset_right = -22
					newArrow.offset_top = -22
					newArrow.offset_bottom = -22
					add_child(newArrow)
					newArrow.rotation = global_position.direction_to(box.position).angle()
					addedWidgets.append(newArrow)
		"confidential":
			var count = 0
			for box in main.boxes:
				if box.revealed and not box.destroyed:
					count += 1
			if count >= 18:
				lg("Espionage victory!")
				win()
		"demolition":
			main.add_status(StatusTypes.DEMOLISH, 1)
		"desert":
			var count = 0
			for box in main.boxes:
				if box.destroyed:
					count += 1
			if count >= 11:
				lg("Desert sands victory!")
				win()
		"dice":
			set_custom_num(2)
		"dna":
			dnaTransform()
		"dragon":
			var winning = false
			for box in main.boxes:
				if box.id == "sword" and box.open and !box.destroyed:
					winning = true
			if winning:
				lg("The Dragon has been slain!")
				win()
			else:
				lg("The Dragon slays you!")
				lose()
		"exp":
			set_custom_num(9)
		"fairy":
			var valids = []
			for box in main.boxes:
				if !box.destroyed and !box.revealed and box.id != "fairy":
					valids.append(box)
			if valids.size() > 0:
				var toChange = valids.pick_random()
				toChange.loadType("fairy")
			var count = 0
			for box in main.boxes:
				if box.open and !box.destroyed and box.id == "fairy":
					count += 1
			if count >= 4:
				lg("Four or more fairies - you win!")
				win()
		"finalboss":
			if main.rng.randi_range(0, 19) == 0 and main.getBoxStat("finalboss", "opens") > 2:
				modStat("timesActivated", 1)
				destroyBox()
				lg("WHAT IS HAPPENING???")
				lg("WASD TO... MOVE?")
				main.start_big_bossfight(self)
		"fire":
			var toChange = get_adjacent_boxes(false, badgeEquipped("flamingmask"))
			var result = []
			for box in toChange:
				if box.id != id:
					result.append(box)
			if result.size() > 0:
				var toHit = result.pick_random()
				toHit.loadType(id)
		"firework":
			for i in 5:
				var valids = []
				for box in main.boxes:
					if box.id != "smartbomb" and !box.destroyed:
						valids.append(box)
				if valids.size() > 0:
					var toChange = valids.pick_random()
					toChange.loadType("smartbomb")
		"fish":
			var count = 0
			for box in main.boxes:
				if box.open and !box.destroyed and box.id == "fish":
					count += 1
			if badgeEquipped("ocean"):
				for box in main.boxes:
					if !box.destroyed and box.id == "waterfall":
						box.revealBox()
			if count >= 3:
				lg("Fish victory - three or more!")
				win()
		"fishingrod":
			for i in 3:
				var list = []
				for box in main.boxes:
					if box.id != "fish" and !box.destroyed and !box.revealed:
						list.append(box)
				if list.size() > 0:
					var toChange = list.pick_random()
					toChange.loadType("fish")
		"gamer":
			if main.winstreak > 0:
				lg("What a gamer! That's a winstreaking GAMER VICTORY!")
				win()
		"gazer":
			set_custom_num(2)
		"ghost":
			for i in 2:
				var valids = []
				for box in main.boxes:
					if !box.destroyed and box != self:
						valids.append(box)
				var toChange = valids.pick_random()
				toChange.loadType("loss")
		"hat":
			var hasWand = false
			var hasCloak = false
			for box in main.boxes:
				if box.id == "wand" and !box.destroyed and box.open:
					hasWand = true
				if box.id == "cloak" and !box.destroyed and box.open:
					hasCloak = true
			if hasWand and hasCloak:
				win()
		"heart":
			set_custom_num(3)
		"ice":
			set_custom_num(3)
		"info":
			for i in 2:
				var toChange = get_adjacent_boxes(true, true)
				if toChange.size() > 0:
					toChange.pick_random().revealBox()
		"instaopen":
			var myRow = main.rows[row]
			if col != 0:
				myRow[col-1].openBox()
			if col < myRow.size() - 1:
				myRow[col+1].openBox()
		"invert":
			if main.has_status(StatusTypes.INVERSION):
				main.remove_status(StatusTypes.INVERSION)
			else:
				main.add_status(StatusTypes.INVERSION, 1)
		"ivy":
			if row > 0:
				var result = []
				var rowAbove = main.rows[row-1]
				if col != 0:
					result.append(rowAbove[col - 1])
				if rowAbove.size() > col:
					result.append(rowAbove[col])
				if result.size() > 0:
					if badgeEquipped("gardener"):
						for box in result:
							if !box.destroyed:
								box.loadType("ivy")
					else:
						var box = result.pick_random()
						if !box.destroyed:
							box.loadType("ivy")
		"jumpscare":
			var count = 0
			for box in main.boxes:
				if box.open and !box.destroyed:
					count += 1
			if count == 1:
				lg("SUPER UNLUCKY! That's a TERRIFYING Jumscare loss!")
				lose()
		"kettle":
			set_custom_num(3)
		"key":
			set_custom_num(1)
		"lock":
			if get_box_counter("key") > 0:
				lg("Key unlocks the Lock Box - VICTORY!")
				win()
		"lonely":
			if get_adjacent_boxes(false, false).size() < 6:
				lg("Lonely Box isn't surrounded!")
				lose()
		"loss":
			lose()
		"map":
			for box in main.boxes:
				if box.id == "treasure" && !box.destroyed:
					box.revealBox()
		"match":
			var list = []
			for box in main.boxes:
				if box.id != "fire" and !box.destroyed:
					list.append(box)
			var toChange = list.pick_random()
			toChange.loadType("fire")
		"meteor":
			for box in get_adjacent_boxes(false, false):
				if box.id == "bedrock" and box.open:
					lg("Meteor hits Bedrock! Stone Smash Victory!")
					win()
		"mimic":
			if main.rng.randi_range(1, 3) == 1:
				lg("The Mimic attacks you viciously!")
				lose()
		"music":
			main.get_node("MusicPlayer").play()
		"onegold":
			main.add_status(StatusTypes.GOLD, 1)
		"paint":
			var result = Color(main.rng.randf_range(0, 0.5), main.rng.randf_range(0, 0.5), main.rng.randf_range(0.5, 1), 1)
			main.get_node("ColorRect").color = result
		"painttwo":
			for box in main.boxes:
				if !box.open and !box.destroyed and !box.revealed:
					box.get_node("Sprite2D").modulate = Color(main.rng.randf_range(0, 1), main.rng.randf_range(0, 1), main.rng.randf_range(0, 1), 1)
		"pandoras":
			for box in main.boxes:
				if box != self and box.revealed and not box.destroyed:
					modStat("timesActivated", 1)
					box.loadType("loss")
		"poison":
			set_custom_num(8)
		"portal":
			set_custom_num(2)
		"poverty":
			if (main.has_status(StatusTypes.GOLD)):
				main.remove_status(StatusTypes.GOLD)
		"princess":
			var willDie = false
			for box in main.boxes:
				if box.id == "dragon" and box.revealed and not box.destroyed:
					willDie = true
			if willDie:
				lg("Princess sees the dragon - you lose!")
				lose()
			else:
				main.add_status(StatusTypes.GOLD, 3)
		"program":
			set_custom_num(6)
		"revealcorners":
			var revealedAny = false
			var topRow = 0
			for row in main.rows:
				var validRow = false
				for box in row:
					if !box.destroyed:
						validRow = true
						break
				if validRow:
					break
				topRow += 1
			for box in main.rows[topRow]:
				if !box.revealed and !box.destroyed:
					revealedAny = true
					box.revealBox()
					modStat("timesActivated", 1)
			var bottomrow = main.unlockedRows - 1
			var made_change = true
			while made_change:
				var valid_corner = false
				for box in main.rows[bottomrow]:
					if !box.destroyed:
						valid_corner = true
				if !valid_corner:
					made_change = true
					bottomrow -= 1
				else:
					made_change = false
			var last = -1
			var didFirst = false
			for box in main.rows[bottomrow]:
				if !box.destroyed:
					if !didFirst:
						if !box.revealed:
							revealedAny = true
							box.revealBox()
							modStat("timesActivated", 1)
						didFirst = true
					last = box.col
			if last != -1:
				var target = main.rows[bottomrow][last]
				if !target.revealed:
					revealedAny = true
					main.rows[bottomrow][last].revealBox()
					modStat("timesActivated", 1)
			if !revealedAny and badgeEquipped("trigazeimprove"):
				lg("Trigaze+ activates - you win!")
				win()
		"revealrandom":
			main.reveal_random()
		"revealrow":
			main.reveal_row(row)
		"revival":
			var valids = []
			for box in main.boxes:
				if box.destroyed:
					valids.append(box)
			var siz = valids.size()
			for i in min(5, siz):
				modStat("timesActivated", 1)
				var toRes = valids.pick_random()
				toRes.reviveBox()
				valids.erase(toRes)
		"rowgold":
			var goldAmt = 0
			for box in main.rows[row]:
				if box != self and box.open:
					goldAmt += 1
			if goldAmt > 0:
				main.add_status(StatusTypes.GOLD, goldAmt)
		"rowwin":
			var willWin = true
			for box in main.rows[row]:
				if !box.open and !box.destroyed:
					willWin = false
			if willWin:
				lg("Full row -> Horizontal Win! Nicely done!")
				win()
				if row >= 9:
					if !main.unlockedBadges.has("widerow"):
						for badge in main.get_node("AchievementsContainer").get_children():
							if badge.id == "widerow" and !badge.unlocked:
								badge.unlock()
		"sacrifice":
			if badgeEquipped("maddii"):
				set_custom_num(15)
			else:
				set_custom_num(5)
		"safety":
			main.add_status(StatusTypes.SAFETY, 1)
		"scrap":
			set_custom_num(0)
		"shadow":
			close_random_other()
		"sleepy":
			for box in main.boxes:
				if !box.destroyed and (box.id == "winner" || box.id == "loss"):
					modStat("destroys", 1)
					box.destroyBox()
		"smartbomb":
			for box in get_adjacent_boxes(true, false):
				box.revealBox()
		"speedrun":
			var count = 0
			for box in main.boxes:
				if box.open and !box.destroyed:
					count += 1
			if count == 1:
				lg("SUPER LUCKY! That's a SPEEDRUN Victory!")
				win()
		"spike":
			var count = 0
			for box in main.boxes:
				if box.open and !box.destroyed and box.id == "spike":
					count += 1
			if count >= 3:
				lg("Slain by spikes!")
				lose()
		"spire":
			if main.badgePoints - main.bpInUse > 0:
				for box in main.boxes: 
					if box.id == "empty" and !box.destroyed:
						box.loadType("winner")
		"stamp":
			var dupeBoxes = []
			var ids = []
			for box in main.boxes:
				if !box.destroyed:
					if ids.has(box.id) and !dupeBoxes.has(box.id) and box.id != "mimic":
						dupeBoxes.append(box.id)
					elif !ids.has(box.id):
						ids.append(box.id)
			for box in main.boxes:
				if !box.destroyed:
					if dupeBoxes.has(box.id):
						box.revealBox()
						modStat("timesActivated", 1)
		"star":
			var adjacents = get_adjacent_boxes(false, false)
			var winning = true
			for box in adjacents:
				if !box.open:
					winning = false
			if winning:
				lg("Star is surrounded - you win!")
				win()
		"starve":
			for i in 5:
				var list = []
				for box in main.boxes:
					if box.id != "food" and !box.destroyed and !box.revealed:
						list.append(box)
				if list.size() > 0:
					var toChange = list.pick_random()
					toChange.loadType("food")
			set_custom_num(7)
		"sus":
			for i in 2:
				var list = []
				for box in main.boxes:
					if box.id != "mimic" and !box.destroyed:
						list.append(box)
				var toChange = list.pick_random()
				var oldType = toChange.id
				toChange.loadType("mimic")
				toChange.heldStr = oldType
				if toChange.revealed and not toChange.open:
					toChange.revealBox()
		"threed":
			for i in 3:
				main.reveal_random()
		"threegold":
			main.add_status(StatusTypes.GOLD, 3)
		"toolbox":
			for box in get_adjacent_boxes(false, false):
				if box.row < row:
					box.loadType("demolition")
					box.revealBox()
				elif box.row > row:
					box.loadType("closenext")
					box.revealBox()
		"transmog":
			main.add_status(StatusTypes.TRANSMOG, 2)
		"treasure":
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
							if box.id == "map":
								willWin = true
								break
							else:
								stack.push_front(box)
			if willWin:
				lg("The treasure map has been solved!")
				win()
		"tripleplay":
			if customNum == -1:
				set_custom_num(1)
			else:
				set_custom_num(customNum + 1)
				if customNum == 3:
					lg("The elusive THREE-OPEN victory!")
					win()
		"twogold":
			main.add_status(StatusTypes.GOLD, 2)
		"underrated":
			var toReveal
			var lowest = 99999
			for box in main.boxes:
				if !box.destroyed and !box.revealed and main.getBoxStat(box.id, "opens") < lowest:
					toReveal = box
					lowest = main.getBoxStat(box.id, "opens")
			if toReveal != null:
				toReveal.revealBox()
		"underworld":
			lose()
			if main.gameRunning:
				win()
		"wand":
			var hasHat = false
			var hasCloak = false
			for box in main.boxes:
				if box.id == "hat" and !box.destroyed and box.open:
					hasHat = true
				if box.id == "cloak" and !box.destroyed and box.open:
					hasCloak = true
			if hasHat and hasCloak:
				win()
		"waterfall":
			if row == main.unlockedRows - 1:
				lg("Waterfall victory!")
				win()
				if !main.unlockedBadges.has("ocean"):
					var count = 0
					for box in main.boxes:
						if box.id == "waterfall" and box.open and !box.destroyed:
							count += 1
					if count >= 10:
						for badge in main.get_node("AchievementsContainer").get_children():
							if badge.id == "ocean" and !badge.unlocked:
								badge.unlock()
			else:
				var valids = []
				for box in main.rows[row+1]:
					if !box.destroyed:
						valids.append(box)
				if valids.size() > 0:
					var toChange = valids.pick_random()
					toChange.loadType("waterfall")
		"winner":
			win()
		"winter":
			for i in 5:
				var valids = []
				for box in main.boxes:
					if box.id != "ice" and !box.destroyed:
						valids.append(box)
				if valids.size() > 0:
					var toChange = valids.pick_random()
					toChange.loadType("ice")
		"butterfly":
			if badgeEquipped("flyingbutterfly") and row > 0:
				var valids = []
				for box in main.rows[row-1]:
					if !box.destroyed:
						valids.append(box)
				if valids.size() > 0:
					var toChange = valids.pick_random()
					toChange.loadType("butterfly")
		"egg":
			if badgeEquipped("heavenegg"):
				for box in main.boxes:
					if (box.id == "poison" or box.id == "heartbreak" or box.id == "dungeon" or box.id == "curse") and !box.destroyed:
						box.destroyBox()
	pass

func on_other_box_opened(box: Box) -> void:
	match id:
		"allseeingeye":
			if customNum > 0:
				if customNum == 1:
					lg("All Seeing Box activates!")
					lose()
				set_custom_num(customNum - 1)
				if main.gameRunning and customNum == 0:
						hide_custom_num()
		"alphabet":
			var regex = RegEx.new()
			regex.compile("[a-zA-Z]+")
			for i in box.nameText.to_lower():
				if regex.search(i):
					arr.append(i)
			var will_win = true
			for letter in alphabet:
				if !arr.has(letter):
					will_win = false
			if will_win:
				lg("The Alphabox is complete!")
				win()
		"armageddon":
			if customNum == 1:
				lg("Armageddon has arrived!")
				main.modBoxStat(id, "timesActivated", 1)
				main.clear_central()
				main.destroy_box(self)
				hide_custom_num()
			elif customNum > 0:
				set_custom_num(customNum - 1)
				lg(str(customNum) + " opens to Armageddon!")
		"autoopen":
			var valids = get_adjacent_boxes(false, true)
			if valids.size() > 0:
				lg(nameText + " is opening a box!")
				main.modBoxStat(id, "timesActivated", 1)
				var toOpen = valids.pick_random()
				toOpen.openBox()
				toOpen.just_opened = true
		"boss":
			if customNum > 0:
				if customNum == 1:
					lg("You slayed the Boss!")
					win()
				set_custom_num(customNum-1)
				if main.gameRunning and customNum == 0:
						hide_custom_num()
		"checkbox":
			if !main.last_opened.was_revealed_when_opened and open and !destroyed and !just_opened:
				modStat("timesActivated", 1)
				main.reveal_random()
		"clone":
			if customNum > 0:
				if customNum == 1:
					var found = get_adjacent_boxes(false, false).pick_random()
					found.revealBox()
					loadType(found.id)
					closeBox()
				else:
					set_custom_num(customNum - 1)
		"clumsy":
			var valids = []
			for other in box.get_adjacent_boxes(false, false):
				valids.append(other)
			if valids.size() > 0:
				lg("Clumsy Box is destroying a box!")
				valids.pick_random().destroyBox()
				modStat("destroys", 1)
		"crumbling":
			for other in main.boxes:
				if !other.destroyed:
					modStat("destroys", 1)
					main.destroy_box(other)
					if other.id == "crumbling" and badgeEquipped("crumblingbuff"):
						lg("Crumbling Irony activates - YOU WIN!")
						win()
					break
		"crystalball":
			for other in box.get_adjacent_boxes(false, false):
				if !other.destroyed:
					if other.id == "hat" or other.id == "cloak" or other.id == "wand":
						other.revealBox()
						modStat("timesActivated", 1)
		"dna":
			if badgeEquipped("reroller"):
				for other in get_adjacent_boxes(false, false):
					if other == box:
						special = 1
						break
				if special == 0:
					dnaTransform()
		"dungeon":
			if box.id != "spike":
				for i in 2:
					var valids = []
					for other in box.get_adjacent_boxes(false, true):
						if other.id != "spike":
							valids.append(other)
					if valids.size() > 0:
						valids.pick_random().loadType("spike")
		"exp":
			if open and !main.last_opened.was_revealed_when_opened and customNum > 0 and !just_opened:
				set_custom_num(customNum-1)
				if customNum == 0:
					lg("Your exploration has resulted in an EXP Victory!")
					win()
					if main.gameRunning:
						hide_custom_num()
		"exploding":
			lg(nameText + " exploded!")
			for other in get_adjacent_boxes(false, false):
				main.destroy_box(other)
				modStat("destroys", 1)
			main.destroy_box(self)
		"gazer":
			for other in get_adjacent_boxes(false, false):
				if other == box:
					set_custom_num(customNum-1)
					if customNum == 0:
						lg("The Gazer sees your actions!")
						lose()
						if main.gameRunning:
							hide_custom_num()
		"heart":
			if customNum > 0:
				set_custom_num(customNum-1)
		"heartbreak":
			if main.rng.randi_range(0, 9) == 9:
				lg(nameText + " activated - oh no!")
				lose()
		"ice":
			if customNum > 0:
				if customNum == 1:
					lg("Ice Box has thawed!")
				set_custom_num(customNum - 1)
		"income":
			if main.rng.randi_range(1, 3) == 1:
				modStat("timesActivated", 1)
				lg(nameText + " generated 1 Gold!")
				main.add_status(StatusTypes.GOLD, 1)
		"kettle":
			if customNum > 0:
				for other in get_adjacent_boxes(false, false):
					if other == box:
						set_custom_num(customNum-1)
						if customNum == 0:
							for i in 5:
								main.reveal_random()
							hide_custom_num()
							break
		"key":
			if customNum > 0:
				set_custom_num(customNum - 1)
		"mine":
			for other in get_adjacent_boxes(false, false):
				if box == other:
					lg("Mined some gold!")
					modStat("timesActivated", 1)
					main.add_status(StatusTypes.GOLD, 1)
		"poison":
			if customNum > 0:
				set_custom_num(customNum - 1)
				if customNum <= 0:
					lg("You succumb to poison!")
					lose()
					if main.gameRunning:
						hide_custom_num()
		"program":
			set_custom_num(customNum - 1)
			if customNum <= 0:
				hide_custom_num()
		"rowbomb":
			lg(nameText + " exploded!")
			for other in main.rows[row]:
				if other != self and !other.destroyed:
					modStat("destroys", 1)
					main.destroy_box(other)
			modStat("destroys", 1)
			main.destroy_box(self)
		"selfdestruct":
			lg(nameText + " exploded!")
			main.destroy_box(self)
		"shy":
			if main.rng.randi_range(0, 2) == 2:
				modStat("timesActivated", 1)
				closeBox()
		"smartbomb":
			lg(nameText + " exploded!")
			for other in get_adjacent_boxes(false, false):
				main.destroy_box(other)
				modStat("destroys", 1)
			modStat("destroys", 1)
			main.destroy_box(self)
		"starve":
			if customNum > 0:
				if customNum == 1:
					lg("The Hungry Box starves!")
					lose()
				set_custom_num(customNum - 1)
				if main.gameRunning and customNum == 0:
					hide_custom_num()
		"stuck":
			var willWin = true
			for other in main.boxes:
				if other.canOpen():
					willWin = false
			if willWin:
				lg("No boxes to open! Softlock Box activates!")
				win()
		"teacher":
			var valids = get_adjacent_boxes(true, false)
			if valids.size() > 0:
				modStat("timesActivated", 1)
				lg(nameText + " activated!")
				var toReveal = valids.pick_random()
				toReveal.revealBox()
		"virus":
			if special != 1:
				for other in get_adjacent_boxes(false, false):
					if other.revealed and other.open and other.id != "virus":
						modStat("timesActivated", 1)
						other.loadType("virus")
						other.special = 1
	pass

func on_other_box_opened_immediate(box: Box) -> void:
	match id:
		"stellar":
			if open:
				for i in 3:
					var newStar = starScene.instantiate()
					newStar.global_position.x = box.global_position.x
					newStar.global_position.y = box.global_position.y
					main.addVfx(newStar)
	pass

func can_use() -> bool:
	match id:
		"rowwin":
			if badgeEquipped("widerow"):
				var willWin = true
				for box in main.rows[row]:
					if !box.open and !box.destroyed:
						willWin = false
				return willWin
			return false
		"cannon":
			for box in main.rows[row]:
				if box.col > col and !box.destroyed:
					return true
			return false
		"cauldron":
			return true
		"clock":
			return true
		"daredevil":
			return true
		"darts":
			var total = 0
			for box in main.boxes:
				if box.customNum > 0 and !box.destroyed:
					total += box.customNum
			return total >= 10
		"dice":
			return customNum > 0
		"doubleup":
			var ids = []
			for box in get_adjacent_boxes(false, false):
				if !box.destroyed and box.revealed:
					if ids.has(box.id):
						return true
					else:
						ids.append(box.id)
			return false
		"food":
			return true
		"inferno":
			var count = 0
			for box in main.boxes:
				if box.id == "fire" and box.open and !box.destroyed:
					count += 1
			if count >= 10:
				return true
			return false
		"ladder":
			var canGo = true
			for row in main.rows:
				var oneOpen = false
				var anyBox = false
				for box in row:
					if !box.destroyed:
						anyBox = true
						if box.open:
							if !oneOpen:
								oneOpen = true
							else:
								oneOpen = false
								break
				if !oneOpen and anyBox:
					canGo = false
					break
			return canGo
		"magnifying":
			return main.status_amount(StatusTypes.GOLD) >= 1
		"moon":
			return true
		"otherworld":
			return true
		"payforreveals":
			var valids = get_adjacent_boxes(true, false)
			return valids.size() > 0 and main.status_amount(StatusTypes.GOLD) > 0
		"payforshield":
			var otherBoxIsOpen = false
			for box in main.boxes:
				if box.open and !box.destroyed and box != self:
					otherBoxIsOpen = true
					break
			return main.status_amount(StatusTypes.GOLD) >= 1 and otherBoxIsOpen
		"portal":
			return customNum > 0
		"sacrifice":
			return customNum > 0
		"scrap":
			return customNum > 0
		"slots":
			return main.status_amount(StatusTypes.GOLD) >= 2
		"spendtowin":
			return main.status_amount(StatusTypes.GOLD) >= 6
	return false

func on_self_clicked() -> void:
	match id:
		"rowwin":
			main.play_sfx(SFXTypes.ACTIVATE)
			lg("Full row -> Horizontal Win! Nicely done!")
			win()
		"cannon":
			main.play_sfx(SFXTypes.ACTIVATE)
			for box in main.rows[row]:
				if box.col > col and !box.destroyed:
					box.destroyBox()
					break
		"cauldron":
			main.play_sfx(SFXTypes.ACTIVATE)
			for box in main.boxes:
				if box.customNum >= 0 and box.get_node("Number").visible:
					box.set_custom_num(box.customNum+1)
					modStat("timesActivated", 1)
			destroyBox()
		"clock":
			main.play_sfx(SFXTypes.ACTIVATE)
			fNum = 0
		"daredevil":
			modStat("timesActivated", 1)
			var result = main.rng.randi_range(0, 9)
			main.play_sfx(SFXTypes.ACTIVATE)
			if result <= 1:
				lg("Lucky! Daredevil Box made you win!")
				win()
			elif result <= 4:
				lg("Daredevil Box made you lose!")
				lose()
			else:
				lg("Daredevil Box didn't do anything!")
		"darts":
			main.play_sfx(SFXTypes.ACTIVATE)
			lg("More than 15 numbers - nice job!")
			win()
		"dice":
			main.play_sfx(SFXTypes.ACTIVATE)
			for box in get_adjacent_boxes(false, false):
				var valids = []
				for i in main.all_boxes:
					if i != box.id and i != "max":
						valids.append(i)
				if valids.size() > 0:
					box.loadType(valids.pick_random())
			set_custom_num(customNum-1)
		"doubleup":
			main.play_sfx(SFXTypes.ACTIVATE)
			lg("There are two identical boxes next to the Two Box! Nice!")
			win()
		"food":
			main.play_sfx(SFXTypes.ACTIVATE)
			for box in main.boxes:
				if box.id == "starve" and box.open and box.customNum > 0 and !box.destroyed:
					box.set_custom_num(7)
			destroyBox()
		"inferno":
			main.play_sfx(SFXTypes.ACTIVATE)
			lg("The board is awash with flame! Inferno Victory!")
			win()
		"ladder":
			main.play_sfx(SFXTypes.ACTIVATE)
			lg("A full ladder - well done! Ladder Victory!")
			win()
		"magnifying":
			if main.status_amount(StatusTypes.GOLD) >= 1:
				modStat("timesActivated", 1)
				main.play_sfx(SFXTypes.ACTIVATE)
				main.modStat("goldSpent", 1)
				main.change_status_amount(StatusTypes.GOLD, -1)
				main.reveal_random()
		"moon":
			main.play_sfx(SFXTypes.ACTIVATE)
			for i in 5:
				var valids = []
				for box in main.boxes:
					if !box.destroyed and box.open and box != self:
						valids.append(box)
				if valids.size() > 0:
					main.play_sfx(SFXTypes.ACTIVATE)
					var toClose = valids.pick_random()
					toClose.closeBox()
			destroyBox()
		"otherworld":
			destroyBox()
			for box in main.boxes:
				if !box.destroyed and box.revealed:
					var valids = []
					for i in main.all_boxes:
						if i != box.id and i != "max":
							valids.append(i)
					if valids.size() > 0:
						box.loadType(valids.pick_random())
		"payforreveals":
			var valids = get_adjacent_boxes(true, false)
			if valids.size() > 0:
				if main.status_amount(StatusTypes.GOLD) > 0:
					modStat("timesActivated", 1)
					main.play_sfx(SFXTypes.ACTIVATE)
					main.change_status_amount(StatusTypes.GOLD, -1)
					main.modStat("goldSpent", 1)
					var toReveal = valids.pick_random()
					toReveal.revealBox()
		"payforshield":
			if main.status_amount(StatusTypes.GOLD) >= 1:
				var valids = []
				for box in main.boxes:
					if !box.destroyed and box.open and box != self:
						valids.append(box)
				if valids.size() > 0:
					modStat("timesActivated", 1)
					main.play_sfx(SFXTypes.ACTIVATE)
					main.change_status_amount(StatusTypes.GOLD, -1)
					main.modStat("goldSpent", 1)
					var toClose = valids.pick_random()
					toClose.closeBox()
		"portal":
			if customNum > 0:
				main.play_sfx(SFXTypes.ACTIVATE)
				main.add_status(StatusTypes.SWAP, 1)
				for status in main.get_node("StatusList").get_children():
					if status.type == StatusTypes.SWAP:
						status.stored = self
				set_custom_num(customNum - 1)
		"sacrifice":
			if customNum > 0:
				modStat("timesActivated", 1)
				main.play_sfx(SFXTypes.ACTIVATE)
				var thingy = main
				var toChange = thingy.get_random_box()
				main.destroy_box(toChange)
				thingy.reveal_random()
				set_custom_num(customNum - 1)
		"scrap":
			main.play_sfx(SFXTypes.ACTIVATE)
			modStat("timesActivated", 1)
			main.reveal_random()
			set_custom_num(customNum-1)
		"slots":
			if main.status_amount(StatusTypes.GOLD) >= 2:
				modStat("timesActivated", 1)
				main.play_sfx(SFXTypes.ACTIVATE)
				main.change_status_amount(StatusTypes.GOLD, -2)
				main.modStat("goldSpent", 2)
				for i in 4:
					var valids = []
					for box in main.boxes:
						if box.id != "winner" and !box.destroyed and !box.revealed:
							valids.append(box)
					if valids.size() > 0:
						var toChange = valids.pick_random()
						toChange.loadType("winner")
		"spendtowin":
			if main.status_amount(StatusTypes.GOLD) >= 6:
				lg("Pay to win!")
				main.play_sfx(SFXTypes.ACTIVATE)
				main.change_status_amount(StatusTypes.GOLD, -6)
				main.modStat("goldSpent", 6)
				win()
	pass

func can_destroy() -> bool:
	match id:
		"bedrock":
			if open:
				lg("Bedrock Box can't be destroyed!")
			return !open
	for box in get_adjacent_boxes(false, false):
		if box.id == "bedrock" and box.open and !box.destroyed:
			lg(getName() + " can't be destroyed due to the Bedrock Box!")
			return false
	return true

func on_destroy() -> void:
	match id:
		"egg":
			if open:
				lg("The Egg has hatched!")
				win()
		"music":
			if open:
				var stopMusic = true
				for box in main.boxes:
					if box != self and box.id == "music" and box.open and !box.destroyed:
						stopMusic = false
				if stopMusic:
					main.get_node("MusicPlayer").stop()
		"worldbearer":
			if open:
				lg("The Worldbearer has fallen!")
				lose()
	pass

func on_other_box_destroyed(box: Box) -> void:
	match id:
		"flying":
			if open and !destroyed:
				modStat("timesActivated", 1)
				var replacement = flyingBoxScene.instantiate()
				replacement.loadFromBox(box)
				main.addVfx(replacement)
		"scrap":
			if open and !destroyed:
				if customNum <= 0:
					set_custom_num(1)
				else:
					set_custom_num(customNum+1)
	pass

func on_reveal(_was_already_revealed: bool) -> void:
	match id:
		"mimic":
			if heldStr == null or heldStr == "":
				var replacement = id
				while replacement == id:
					replacement = main.all_boxes[main.rng.randi_range(0, main.unlockedBoxes - 1)]
					heldStr = replacement
			var orig_type := id
			id = heldStr
			load_img()
			load_text()
			$Sprite2D.texture = revealedImg
			id = orig_type
	pass

func on_other_box_revealed(box: Box) -> void:
	match id:
		"impatient":
			if !destroyed and open and !box.open and box.row == row:
				modStat("timesActivated", 1)
				main.logToLog(revealedImg, "Impatient Box opens the revealed box!", "impatient")
				box.openBox()

	pass

func on_type_about_to_change(_new_type: String) -> void:
	match id:
		"butterfly":
			if open:
				lg("The Butterfly has evolved!")
				win()
		"music":
			if open:
				var stopMusic = true
				for box in main.boxes:
					if box != self and box.id == "music" and box.open and !box.destroyed:
						stopMusic = false
				if stopMusic:
					main.get_node("MusicPlayer").stop()
	pass

func on_type_changed(_old_type: String) -> void:
	pass

func on_other_box_type_changed(box: Box) -> void:
	match id:
		"flower":
			if open and !destroyed:
				modStat("timesActivated", 1)
				lg("Flower Box closes and reveals the transformed box!")
				box.closeBox()
				box.revealBox()
	pass

func on_close() -> void:
	match id:
		"alphabet":
			arr.clear()
		"music":
			var stopMusic = true
			for box in main.boxes:
				if box != self and box.id == "music" and box.open and !box.destroyed:
					stopMusic = false
			if stopMusic:
				main.get_node("MusicPlayer").stop()
	pass

func should_hide_custom_num() -> bool:
	match id:
		"tripleplay":
			return false
	return !open

func destroyBox():
	if !destroyed:
		if !can_destroy():
			return
		main.play_sfx(SFXTypes.DESTROY)
		if revealed:
			lg(getName() + " was destroyed!")
		destroyed = true
		visible = false
		hide_custom_num()
		on_destroy()
		for box in main.boxes:
			if box.open and not box.destroyed and main.gameRunning:
				box.on_other_box_destroyed(self)
		main.modStat("destroys", 1)
		for badge in main.get_node("AchievementsContainer").get_children():
			badge.postDestroyBox(self)

func reviveBox():
	if destroyed:
		destroyed = false
		visible = true
		closeBox()

func loadBox(new_type: String, new_row: int, new_col: int) -> void:
	row = new_row
	col = new_col
	loadType(new_type)

func loadType(new_type: String) -> void:
	if new_type != id:
		if revealed:
			main.play_sfx(SFXTypes.TRANSMOG)
		hide_custom_num()
		var old_type = id
		for widget in addedWidgets:
			remove_child(widget)
		addedWidgets.clear()
		on_type_about_to_change(new_type)
		var oldName = getName()
		id = new_type
		#var properties := {}
		#for i in propery_names:
			#properties[i] = get(i)
		#set_script(get_box_script(id))
		#set_process(true)
		#for i in properties:
			#set(i, properties[i])
		load_text()
		load_img()
		just_opened = true
		on_type_changed(old_type)
		if !main.loadingGame:
			if revealed:
				lg(oldName + " was transformed into " + getName() + "!")
			for box in main.boxes:
				box.on_other_box_type_changed(self)
			main.modStat("transforms", 1)
			for badge in main.get_node("AchievementsContainer").get_children():
				badge.onBoxTypeChanged(self)
			postTransform()

func revealBox():
	if !destroyed:
		var was_already_revealed = revealed
		revealed = true
		$Sprite2D.texture = revealedImg
		if !open:
			$Outline.texture = outlineRevealed
		on_reveal(was_already_revealed)
		if !was_already_revealed:
			$Sprite2D.modulate = Color(0.6, 0.6, 0.6, 1)
			main.play_sfx(SFXTypes.REVEAL)
			lg(nameText + " was revealed!")
			main.modStat("reveals", 1)
			for box in main.boxes:
				box.on_other_box_revealed(self)
			for badge in main.get_node("AchievementsContainer").get_children():
				badge.postRevealBox(self)

func openBox():
	if !destroyed and !open:
		main.play_sfx(SFXTypes.OPEN)
		main.modBoxStat(id, "opens", 1)
		was_revealed_when_opened = revealed
		revealed = true
		just_opened = true
		open = true
		$Outline.texture = outlineOpen
		load_img()
		$Sprite2D.modulate = Color(1, 1, 1, 1)
		lg("Opened " + ("Mimic Box" if id=="mimic" else nameText))
		on_open()
		for box in main.boxes:
			if box != self:
				box.on_other_box_opened_immediate(self)

func closeBox():
	if open:
		$Sprite2D.modulate = Color(0.6, 0.6, 0.6, 1)
		main.play_sfx(SFXTypes.CLOSE)
		lg(nameText + " was closed.")
		open = false
		if should_hide_custom_num():
			hide_custom_num()
		for widget in addedWidgets:
			remove_child(widget)
		addedWidgets.clear()
		on_close()
		$Outline.texture = outlineRevealed

func getName():
	var curName = "Unknown Box"
	if revealed:
		if id == "mimic" and get("disguise") != null and revealed and not open:
			id = get("disguise")
			load_text()
			curName = nameText
			id = "mimic"
			load_text()
		else:
			curName = nameText
	return curName

func updateTooltipForMe():
	var curName = "Unknown Box"
	var curStatus = "Closed"
	var curDesc = "What could be inside?"
	if revealed:
		if id == "mimic" and get("disguise") != null and revealed and not open:
			id = get("disguise")
			load_text()
			curName = nameText
			curStatus = "Revealed"
			curDesc = tooltipText
			id = "mimic"
			load_text()
		else:
			curName = nameText
			if open:
				curStatus = "Opened"
			else:
				curStatus = "Revealed"
			curDesc = tooltipText
	main.get_node("Tooltip").setup(curName, curStatus, curDesc + addText())
	if revealed:
		main.get_node("Tooltip").setupStats(main.getBoxStat(id, "opens"), main.getBoxStat(id, "wins"))

func addText() -> String:
	match id:
		"alphabet":
			var result = " Letters left: "
			for letter in alphabet:
				if !arr.has(letter):
					result = result + letter
			return result
	return ""

static var cursorTransmog = preload("res://cursorImgs/cursorTransmog.png")
static var cursorDestroy = preload("res://cursorImgs/cursorDestroy.png")
static var cursorClose = preload("res://cursorImgs/cursorClose.png")
static var cursorReveal = preload("res://cursorImgs/cursorReveal.png")
static var cursorUse = preload("res://cursorImgs/cursorUse.png")
static var cursorNo = preload("res://cursorImgs/cursorNo.png")
static var cursorOpen = preload("res://cursorImgs/cursorOpen.png")
static var cursorNormal = preload("res://cursorImgs/cursorNormal.png")
static var cursorPortal = preload("res://cursorImgs/cursorPortal.png")

func updateCursorForMe():
	if !Input.is_action_pressed("pan"):
		var normCursor = true
		if !destroyed:
			if main.has_status(StatusTypes.DEMOLISH) and can_destroy():
				normCursor = false
				Input.set_custom_mouse_cursor(cursorDestroy)
			elif main.has_status(StatusTypes.SWAP):
				normCursor = false
				Input.set_custom_mouse_cursor(cursorPortal)
			else:
				if revealed and main.has_status(StatusTypes.TRANSMOG):
					normCursor = false
					Input.set_custom_mouse_cursor(cursorTransmog)
				else:
					if !open:
						if main.has_status(StatusTypes.SAFETY) and !revealed:
							normCursor = false
							Input.set_custom_mouse_cursor(cursorReveal)
					else:
						if main.has_status(StatusTypes.CLOSENEXT) and id != "closenext":
							normCursor = false
							Input.set_custom_mouse_cursor(cursorClose)
						elif can_use():
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

func _process(_delta):
	if !main.big_bossfight:
		var mousePos = get_viewport().get_mouse_position()
		if mousePos.x >= global_position.x - 37.5 and mousePos.x <= global_position.x + 37.5 and mousePos.y >= global_position.y - 37.5 and mousePos.y <= global_position.y + 37.5:
			if !destroyed:
				updateTooltipForMe()
			if main.gameRunning:
				updateCursorForMe()
		special_process(_delta)

func special_process(delta):
	match (id):
		"clock":
			if !destroyed and open and main.gameRunning and customNum > 0:
				fNum -= delta
				if fNum <= 0:
					fNum += 1
					set_custom_num(customNum-1)
					if customNum == 0:
						lg("Time's up!")
						lose()
						if main.gameRunning:
							hide_custom_num()
		"smiley":
			if !destroyed and open and main.gameRunning:
				fNum -= delta
				if fNum <= 0:
					fNum += 0.3
					var newSmiley = smileyScene.instantiate()
					get_parent().addVfx(newSmiley)

func get_adjacent_boxes(notRevealed, notOpen):
	var result = []
	var myRow = main.rows[row]
	if col != 0:
		result.append(myRow[col - 1])
	if col < myRow.size() - 1:
		result.append(myRow[col+1])
	if row > 0:
		var rowAbove = main.rows[row-1]
		if col != 0:
			result.append(rowAbove[col - 1])
		if rowAbove.size() > col:
			result.append(rowAbove[col])
	if row < main.unlockedRows - 1:
		var rowBelow = main.rows[row+1]
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
	main.last_opened = self
	openBox()
	main.await_postclick()

func get_box_counter(id):
	for box in main.boxes:
		if box.id == id and box.customNum >= 0 and !box.destroyed:
			return box.customNum
	return 0

func box_is_open(id):
	for box in main.boxes:
		if box.id == id and box.open and !box.destroyed:
			return true
	return false

func canOpen():
	if !main.gameRunning or main.loadingGame:
		return false
	var can_open = true
	if box_is_open("territory"):
		can_open = false
		for box in get_adjacent_boxes(false, false):
			if box.open:
				can_open = true
				break
	for box in get_adjacent_boxes(false, false):
		if box.id == "ice" and box.customNum > 0 and !box.destroyed and box.open:
			can_open = false
	if get_box_counter("program") > 0:
		for boxRow in main.rows:
			for other in boxRow:
				if !other.destroyed and !other.open:
					if other.row < row:
						can_open = false
						break
	return can_open

func tryOpen():
	if canOpen():
		innerOpen()

func close_random_other():
	var valids = []
	for box in main.boxes:
		if box.open and box != self and !box.destroyed:
			valids.append(box)
	if valids.size() > 0:
		var toClose = valids.pick_random()
		toClose.closeBox()

func lg(text):
	main.logToLog($Sprite2D.texture, text, id if revealed else null)

func _on_button_pressed() -> void:
	if main.gameRunning && !main.awaiting_post_click and !main.big_bossfight:
		if main.has_status(StatusTypes.DEMOLISH) and can_destroy():
			var owned = main
			main.destroy_box(self)
			owned.change_status_amount(StatusTypes.DEMOLISH, -1)
			main.update_stat_texts()
		elif main.has_status(StatusTypes.SWAP):
			main.get_node("SpawnSoundPlayer").play()
			var oldPos = global_position
			var oldOriginX = origPosX
			var oldOriginY = origPosY
			var oldRow = row
			var oldCol = col
			var other = main.get_status(StatusTypes.SWAP).stored
			global_position = other.global_position
			origPosX = other.origPosX
			origPosY = other.origPosY
			row = other.row
			col = other.col
			main.rows[other.row][other.col] = self
			other.global_position = oldPos
			other.origPosX = oldOriginX
			other.origPosY = oldOriginY
			other.row = oldRow
			other.col = oldCol
			main.rows[oldRow][oldCol] = other
			main.change_status_amount(StatusTypes.SWAP, -1)
		else:
			if main.has_status(StatusTypes.TRANSMOG) and revealed:
				var valids = []
				for newType in main.all_boxes:
					if newType != id and newType != "max":
						valids.append(newType)
				var typeToAdd = valids.pick_random()
				loadType(typeToAdd)
				main.change_status_amount(StatusTypes.TRANSMOG, -1)
			else:
				if !open:
					if main.has_status(StatusTypes.SAFETY):
						if not revealed:
							revealBox()
							main.change_status_amount(StatusTypes.SAFETY, -1)
							main.update_stat_texts()
						else:
							tryOpen()
					else:
						tryOpen()
				else:
					if main.has_status(StatusTypes.CLOSENEXT) and id != "closenext":
						closeBox()
						main.change_status_amount(StatusTypes.CLOSENEXT, -1)
						main.update_stat_texts()
					else:
						if can_use():
							on_self_clicked()
							for box in main.boxes:
								if box.open:
									box.on_other_box_click_activated(self)
							for badge in main.get_node("AchievementsContainer").get_children():
								badge.postUseBoxClick(self)
							main.update_stat_texts()
	else:
		if !main.gameRunning:
			main.startGame()

func win():
	if !main.statsMap[id].has("wins"):
		main.statsMap[id]["wins"] = 1
	else:
		main.statsMap[id]["wins"] += 1
	main.win()

func lose():
	if !main.statsMap[id].has("losses"):
		main.statsMap[id]["losses"] = 1
	else:
		main.statsMap[id]["losses"] += 1
	main.lose()

func modStat(statId, val):
	main.modBoxStat(id, statId, val)

func badgeEquipped(id):
	return main.hasBadge(id)

func on_other_box_click_activated(box) -> void:
	match id:
		"candy":
			main.reveal_random()
			modStat("timesActivated", 1)
	pass

func postTransform():
	if open:
		match id:
			"compass":
				on_open()
			"music":
				on_open()
	pass


static var imgTable = {
	"winner": preload("res://boxImgs/winner.png"),
	"empty": preload("res://boxImgs/empty.png"),
	"loss": preload("res://boxImgs/loss.png"),
	"revealrandom": preload("res://boxImgs/revealrandom.png"),
	"revealrow": preload("res://boxImgs/revealrow.png"),
	"onegold": preload("res://boxImgs/onegold.png"),
	"poison": preload("res://boxImgs/poison.png"),
	"antidote": preload("res://boxImgs/antidote.png"),
	"exploding": preload("res://boxImgs/exploding.png"),
	"payforreveals": preload("res://boxImgs/payforreveals.png"),
	"star": preload("res://boxImgs/star.png"),
	"shadow": preload("res://boxImgs/shadow.png"),
	"jumpscare": preload("res://boxImgs/jumpscare.png"),
	"safety": preload("res://boxImgs/safety.png"),
	"twogold": preload("res://boxImgs/twogold.png"),
	"fire": preload("res://boxImgs/fire.png"),
	"threegold": preload("res://boxImgs/threegold.png"),
	"spendtowin": preload("res://boxImgs/spendtowin.png"),
	"revealcorners": preload("res://boxImgs/revealcorners.png"),
	"dragon": preload("res://boxImgs/dragon.png"),
	"sword": preload("res://boxImgs/sword.png"),
	"ghost": preload("res://boxImgs/ghost.png"),
	"clock": preload("res://boxImgs/clock.png"),
	"books": preload("res://boxImgs/books.png"),
	"sacrifice": preload("res://boxImgs/sacrifice.png"),
	"poverty": preload("res://boxImgs/poverty.png"),
	"closeadjacent": preload("res://boxImgs/closeadjacent.png"),
	"threed": preload("res://boxImgs/threed.png"),
	"income": preload("res://boxImgs/income.png"),
	"boss": preload("res://boxImgs/boss.png"),
	"shy": preload("res://boxImgs/shy.png"),
	"mimic": preload("res://boxImgs/mimic.png"),
	"curse": preload("res://boxImgs/curse.png"),
	"payforshield": preload("res://boxImgs/payforshield.png"),
	"heart": preload("res://boxImgs/heart.png"),
	"music": preload("res://boxImgs/music.png"),
	"sus": preload("res://boxImgs/sus.png"),
	"speedrun": preload("res://boxImgs/speedrun.png"),
	"demolition": preload("res://boxImgs/demolition.png"),
	"heartbreak": preload("res://boxImgs/heartbreak.png"),
	"rowbomb": preload("res://boxImgs/rowbomb.png"),
	"closenext": preload("res://boxImgs/closenext.png"),
	"autoopen": preload("res://boxImgs/autoopen.png"),
	"rowwin": preload("res://boxImgs/rowwin.png"),
	"teacher": preload("res://boxImgs/teacher.png"),
	"armageddon": preload("res://boxImgs/armageddon.png"),
	"bedrock": preload("res://boxImgs/bedrock.png"),
	"cloak": preload("res://boxImgs/cloak.png"),
	"desert": preload("res://boxImgs/desert.png"),
	"fairy": preload("res://boxImgs/fairy.png"),
	"hat": preload("res://boxImgs/hat.png"),
	"invert": preload("res://boxImgs/invert.png"),
	"selfdestruct": preload("res://boxImgs/selfdestruct.png"),
	"wand": preload("res://boxImgs/wand.png"),
	"instaopen": preload("res://boxImgs/instaopen.png"),
	"blackjack": preload("res://boxImgs/blackjack.png"),
	"egg": preload("res://boxImgs/egg.png"),
	"inferno": preload("res://boxImgs/inferno.png"),
	"key": preload("res://boxImgs/key.png"),
	"lock": preload("res://boxImgs/lock.png"),
	"match": preload("res://boxImgs/match.png"),
	"pandoras": preload("res://boxImgs/pandoras.png"),
	"revival": preload("res://boxImgs/revival.png"),
	"smartbomb": preload("res://boxImgs/smartbomb.png"),
	"territory": preload("res://boxImgs/territory.png"),
	"worldbearer": preload("res://boxImgs/worldbearer.png"),
	"princess": preload("res://boxImgs/princess.png"),
	"mine": preload("res://boxImgs/mine.png"),
	"clone": preload("res://boxImgs/clone.png"),
	"gamer": preload("res://boxImgs/gamer.png"),
	"magnifying": preload("res://boxImgs/magnifying.png"),
	"virus": preload("res://boxImgs/virus.png"),
	"starve": preload("res://boxImgs/starve.png"),
	"spire": preload("res://boxImgs/spire.png"),
	"crumbling": preload("res://boxImgs/crumbling.png"),
	"tripleplay": preload("res://boxImgs/tripleplay.png"),
	"food": preload("res://boxImgs/food.png"),
	"allseeingeye": preload("res://boxImgs/allseeingeye.png"),
	"waterfall": preload("res://boxImgs/waterfall.png"),
	"meteor": preload("res://boxImgs/meteor.png"),
	"daredevil": preload("res://boxImgs/daredevil.png"),
	"paint": preload("res://boxImgs/paint.png"),
	"ice": preload("res://boxImgs/ice.png"),
	"bullseye": preload("res://boxImgs/bullseye.png"),
	"confidential": preload("res://boxImgs/confidential.png"),
	"fishingrod": preload("res://boxImgs/fishingrod.png"),
	"impatient": preload("res://boxImgs/impatient.png"),
	"transmog": preload("res://boxImgs/transmog.png"),
	"stuck": preload("res://boxImgs/stuck.png"),
	"fish": preload("res://boxImgs/fish.png"),
	"dna": preload("res://boxImgs/dna.png"),
	"guardian": preload("res://boxImgs/guardian.png"),
	"painttwo": preload("res://boxImgs/painttwo.png"),
	"moon": preload("res://boxImgs/moon.png"),
	"butterfly": preload("res://boxImgs/butterfly.png"),
	"map": preload("res://boxImgs/map.png"),
	"treasure": preload("res://boxImgs/treasure.png"),
	"checkbox": preload("res://boxImgs/checkbox.png"),
	"stellar": preload("res://boxImgs/stellar.png"),
	"flying": preload("res://boxImgs/flying.png"),
	"underworld": preload("res://boxImgs/underworld.png"),
	"program": preload("res://boxImgs/program.png"),
	"sleepy": preload("res://boxImgs/sleepy.png"),
	"exp": preload("res://boxImgs/exp.png"),
	"ivy": preload("res://boxImgs/ivy.png"),
	"flower": preload("res://boxImgs/flower.png"),
	"finalboss": preload("res://boxImgs/finalboss.png"),
	"compass": preload("res://boxImgs/compass.png"),
	"slots": preload("res://boxImgs/slots.png"),
	"scrap": preload("res://boxImgs/scrap.png"),
	"info": preload("res://boxImgs/info.png"),
	"ladder": preload("res://boxImgs/ladder.png"),
	"portal": preload("res://boxImgs/portal.png"),
	"winter": preload("res://boxImgs/winter.png"),
	"dice": preload("res://boxImgs/dice.png"),
	"darts": preload("res://boxImgs/darts.png"),
	"spike": preload("res://boxImgs/spike.png"),
	"dungeon": preload("res://boxImgs/dungeon.png"),
	"cauldron": preload("res://boxImgs/cauldron.png"),
	"alphabet": preload("res://boxImgs/alphabet.png"),
	"stamp": preload("res://boxImgs/stamp.png"),
	"clumsy": preload("res://boxImgs/clumsy.png"),
	"smiley": preload("res://boxImgs/smiley.png"),
	"crystalball": preload("res://boxImgs/crystalball.png"),
	"badgebox": preload("res://boxImgs/badgebox.png"),
	"candy": preload("res://boxImgs/candy.png"),
	"toolbox": preload("res://boxImgs/toolbox.png"),
	"kettle": preload("res://boxImgs/kettle.png"),
	"cannon": preload("res://boxImgs/cannon.png"),
	"otherworld": preload("res://boxImgs/otherworld.png"),
	"rowgold": preload("res://boxImgs/rowgold.png"),
	"gazer": preload("res://boxImgs/gazer.png"),
	"firework": preload("res://boxImgs/firework.png"),
	"doubleup": preload("res://boxImgs/doubleup.png"),
	"lonely": preload("res://boxImgs/lonely.png"),
	"underrated": preload("res://boxImgs/underrated.png")
}


# specifics
func dnaTransform():
	var revealAllAdjacent = false
	var newType = main.all_boxes[main.rng.randi_range(0, main.unlockedBoxes - 1)]
	for box in get_adjacent_boxes(false, false):
		if box.id != newType:
			box.loadType(newType)
			if box.revealed:
				revealAllAdjacent = true
	if revealAllAdjacent:
		for box in get_adjacent_boxes(true, false):
			box.revealBox()
