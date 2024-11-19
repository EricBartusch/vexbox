class_name Protag
extends Node2D

var bullet_scene = preload("res://battle/bullet.tscn")

static var SPEED = 500
static var SHOT_TIMER = 0.2
var timer = 0
var flashing = false
var perFlash = 0

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
	if get_parent().big_bossfight and get_parent().curBossfightStatus == 2:
		look_at(get_global_mouse_position())
		if Input.is_action_pressed("protag_up"):
			position.y -= SPEED * delta
			if position.y < 75:
				position.y = 75
		if Input.is_action_pressed("protag_down"):
			position.y += SPEED  * delta
			if position.y > 1080 - 75:
				position.y = 1080-75
		if Input.is_action_pressed("protag_left"):
			position.x -= SPEED * delta
			if position.x < 75:
				position.x = 75
		if Input.is_action_pressed("protag_right"):
			position.x += SPEED * delta
			if position.x >= 1920 - 75:
				position.x = 1920 - 75
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and timer <= 0:
			if get_parent().big_bossfight and get_parent().curBossfightStatus == 2:
				var usedBox = get_random_box()
				if usedBox != null:
					get_parent().get_node("DestroyFXPlayer").play()
					timer = SHOT_TIMER
					var tex = usedBox.get_node("Sprite2D").texture
					var new_bullet = bullet_scene.instantiate()
					new_bullet.get_node("Sprite2D").texture = tex
					new_bullet.rotation = rotation
					new_bullet.position = position
					new_bullet.velocity = new_bullet.velocity.rotated(rotation)
					get_parent().add_dakka(new_bullet)
	if iframes > 0:
		iframes -= delta
		perFlash += delta
		if iframes < 0:
			$Sprite2D.modulate = Color(1, 1, 1, 1)
			for other in $Area2D.get_overlapping_areas():
				if other.get_parent().has_method("touch_protag"):
					other.get_parent().touch_protag($Area2D)
		else:
			if perFlash >= 0.3:
				perFlash = 0
				if flashing:
					flashing = false
					$Sprite2D.modulate = Color(1, 1, 1, 1)
				else:
					flashing = true
					$Sprite2D.modulate = Color(1, 1, 1, 0.6)

func get_random_box():
	var valids = []
	for box in get_parent().boxes:
		if box.customNum != -3:
			valids.append(box)
	if valids.size() > 0:
		return valids.pick_random()

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and timer <= 0:
		#if get_parent().big_bossfight and get_parent().curBossfightStatus == 2:
			#var usedBox = get_random_box()
			#if usedBox != null:
				#get_parent().get_node("DestroyFXPlayer").play()
				#timer = SHOT_TIMER
				#var tex = usedBox.get_node("Sprite2D").texture
				#var new_bullet = bullet_scene.instantiate()
				#new_bullet.get_node("Sprite2D").texture = tex
				#new_bullet.rotation = rotation
				#new_bullet.position = position
				#new_bullet.velocity = new_bullet.velocity.rotated(rotation)
				#get_parent().add_dakka(new_bullet)

static var IFRAMES_MAX = 1.2
var iframes = 0

func whenHit():
	iframes = IFRAMES_MAX
	flashing = true
	perFlash = 0
	$Sprite2D.modulate = Color(1, 1, 1, 0.6)
