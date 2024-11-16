extends Node2D

enum BossState {
	FALLING,
	PHASE_ONE,
	PHASE_TWO,
	DEATH_STARS,
	DEATH_FLYOFF
}

enum Attack {
	SPAWN_ORBS,
	LIGHTNING,
	CLAWS,
	EYEBEAM,
	SHADOWSPIKES,
	MAX
}

enum ExtraAttack {
	HORIZBEAM,
	BREAKER,
	ARCS,
	MAX
}

var health = 5000
var state = BossState.FALLING
var attackInUse = Attack.MAX
var otherAttackInUse = ExtraAttack.MAX
var timer = 2
var attackTimer = 0
var attackIndex = 0

var bolt = preload("res://battle/bolt.tscn")
var claw = preload("res://battle/claw.tscn")
var smallBoolet = preload("res://battle/bossshot.tscn")
var shadowspike = preload("res://battle/shadowspike.tscn")
var turret = preload("res://battle/turret.tscn")
var leftClaw
var rightClaw
var going_up = false
var speed = 100
var lastAttack = Attack.MAX

func _ready() -> void:
	$BossImg.global_position.y -= 1000

func move(delta):
	if speed < 100 if state == BossState.PHASE_ONE else 150:
		speed += delta * 50
	if going_up:
		position.y -= delta * speed
		if leftClaw.timer <= 0:
			leftClaw.position.y -= delta * speed / 3
		if rightClaw.timer <= 0:
			rightClaw.position.y -= delta * speed / 3
		if position.y < 200:
			going_up = false
			speed = 10
	else:
		position.y += delta * speed
		if leftClaw.timer <= 0:
			leftClaw.position.y += delta * speed / 3
		if rightClaw.timer <= 0:
			rightClaw.position.y += delta * speed /3
		if position.y > 900:
			going_up = true
			speed = 10

func mainAttack(delta):
	timer -= delta
	if timer <= 0:
		timer = 3
		attack()
	if timer > 0.75 if state == BossState.PHASE_TWO else 0.9:
		match attackInUse:
			Attack.LIGHTNING:
				attackTimer -= delta
				if attackTimer <= 0:
					attackTimer = 0.07
					var newBolt = bolt.instantiate()
					get_parent().add_dakka(newBolt)
			Attack.CLAWS:
				attackTimer -= delta
				if attackTimer <= 0:
					get_parent().get_node("ActivateFXPlayer").play()
					if attackIndex == 0:
						leftClaw.fire(get_parent().protag)
					else:
						rightClaw.fire(get_parent().protag)
					attackIndex += 1
					attackTimer = 1.5
					pass
			Attack.EYEBEAM:
				attackTimer -= delta
				if attackTimer <= 0:
					get_parent().get_node("ShotSoundPlayer").play()
					attackTimer = 0.3
					var new_bullet = smallBoolet.instantiate()
					new_bullet.rotation = position.direction_to(get_parent().protag.position).angle()
					new_bullet.position = position
					new_bullet.velocity = new_bullet.velocity.rotated(new_bullet.rotation)
					get_parent().add_dakka(new_bullet)
					for i in 3:
						new_bullet = smallBoolet.instantiate()
						new_bullet.rotation = position.direction_to(get_parent().protag.position).angle()
						new_bullet.rotation += (i-1) * get_parent().rng.randf_range(0.1, 0.16)
						new_bullet.position = position
						new_bullet.velocity = new_bullet.velocity.rotated(new_bullet.rotation)
						get_parent().add_dakka(new_bullet)
			Attack.SHADOWSPIKES:
				attackTimer -= delta
				if attackTimer <= 0:
					get_parent().get_node("SummonSoundPlayer").play()
					attackTimer = 0.2
					attackIndex += 1
					if attackIndex == 15:
						attackTimer = 1000
					var loc_x = attackIndex * 100 + get_parent().rng.randi_range(-30, 30)
					var new_spike = shadowspike.instantiate()
					new_spike.global_position.x = loc_x
					get_parent().add_dakka(new_spike)
			Attack.SPAWN_ORBS:
				attackTimer -= delta
				if attackTimer <= 0:
					get_parent().get_node("SpawnSoundPlayer").pitch_scale = 1.0
					get_parent().get_node("SpawnSoundPlayer").play()
					attackTimer = 1.1
					var new_turret = turret.instantiate()
					new_turret.rotation = Vector2.LEFT.rotated(get_parent().rng.randf_range(-0.7, 0.7)).angle()
					new_turret.position = position
					new_turret.velocity = new_turret.velocity.rotated(new_turret.rotation)
					get_parent().add_dakka(new_turret)

var timer2 = 0
var altAttackTimer = 0
var altAttackIndex = 0

var breakerBulletClass = preload("res://battle/breakershot.tscn")

func offAttack(delta):
	timer2 -= delta
	if timer2 <= 0:
		timer2 = 3
		altAttack()
	if timer2 > 0.8:
		match otherAttackInUse:
			ExtraAttack.HORIZBEAM:
				altAttackTimer -= delta
				if altAttackTimer <= 0:
					altAttackTimer = 0.1
					get_parent().get_node("CloseFXPlayer").play()
					var new_bullet = smallBoolet.instantiate()
					new_bullet.rotation = Vector2.LEFT.rotated(get_parent().rng.randf_range(-0.2, 0.2)).angle()
					new_bullet.position = position
					new_bullet.velocity = new_bullet.velocity.rotated(new_bullet.rotation)
					get_parent().add_dakka(new_bullet)
			ExtraAttack.BREAKER:
				altAttackTimer -= delta
				if altAttackTimer <= 0:
					get_parent().get_node("SpawnSoundPlayer").pitch_scale = 0.6
					get_parent().get_node("SpawnSoundPlayer").play()
					altAttackTimer = 99
					var breaker_shot = breakerBulletClass.instantiate()
					breaker_shot.rotation = Vector2.LEFT.rotated(get_parent().rng.randf_range(-0.5, 0.5)).angle()
					breaker_shot.position = position
					breaker_shot.velocity = breaker_shot.velocity.rotated(breaker_shot.rotation)
					get_parent().add_dakka(breaker_shot)
					

var starScene = preload("res://vfx/vfxStar.tscn")

func _process(delta: float) -> void:
	if get_parent().playerHealth > 0:
		match (state):
			BossState.FALLING:
				if timer > 0:
					timer -= delta
					$BossImg.global_position.y += delta * 500
					if timer <= 0:
						get_parent().show_health_bars()
						leftClaw = claw.instantiate()
						leftClaw.position.x = position.x - 300
						leftClaw.position.y = position.y + 50
						rightClaw = claw.instantiate()
						rightClaw.position.x = position.x - 250
						rightClaw.position.y = position.y + 300
						get_parent().add_dakka(leftClaw)
						get_parent().add_dakka(rightClaw)
			BossState.PHASE_ONE:
				move(delta)
				mainAttack(delta)
			BossState.PHASE_TWO:
				move(delta)
				mainAttack(delta)
				offAttack(delta)
			BossState.DEATH_STARS:
				if timer > 0:
					timer -= delta
					var newStar = starScene.instantiate()
					newStar.global_position.x = global_position.x
					newStar.global_position.y = global_position.y
					get_parent().addVfx(newStar)
					$BossImg.modulate.a -= delta / 6
					if timer <= 0:
						state = BossState.DEATH_FLYOFF
						get_parent().win()
						get_parent().postBoss()
						vX = get_parent().rng.randf_range(-10, 10)
						vY = get_parent().rng.randf_range(-20, -6)
			BossState.DEATH_FLYOFF:
				position.x += vX * delta * 30
				position.y += vY * delta * 30
				vY += delta * 25
	if flashTimer > 0:
		flashTimer -= delta
		if flashTimer <= 0:
			$BossImg.modulate = Color(1, 1, 1, 1)

var vX
var vY

func attack():
	var valids = []
	for i in Attack.MAX:
		if lastAttack != i:
			valids.append(i)
	var attackToUse = valids.pick_random()
	if attackToUse == Attack.LIGHTNING:
		get_parent().get_node("ZapSoundPlayer").play()
	elif attackToUse == Attack.SHADOWSPIKES:
		get_parent().get_node("ShadowSpikeSoundPlayer").pitch_scale = 0.3
	attackInUse = attackToUse
	lastAttack = attackInUse
	attackTimer = 0
	attackIndex = 0

func altAttack():
	var secondaryAttack = get_parent().rng.randi_range(0, ExtraAttack.MAX-2)
	otherAttackInUse = secondaryAttack
	altAttackTimer = 0
	altAttackIndex = 0

static var FLASH_AMT = 0.1
var flashTimer = 0

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if state != BossState.DEATH_STARS and state != BossState.DEATH_FLYOFF:
		if area.get_parent() is Bullet:
			get_parent().get_node("RevealFXPlayer").play()
			health -= get_parent().rng.randi_range(25, 50)
			area.get_parent().get_parent().remove_dakka(area.get_parent())
			get_parent().update_boss_healthbar()
			flashTimer = FLASH_AMT
			$BossImg.modulate = Color(1, 1, 1, 0.6)
			if health <= 0:
				die()
			elif health <= 2750 and state == BossState.PHASE_ONE:
				state = BossState.PHASE_TWO
		elif area.get_parent() is Protag and (area.get_parent() as Protag).iframes <= 0:
			touch_protag(area)

func touch_protag(area):
	area.get_parent().get_parent().hurtPlayer()

func die():
	get_parent().curBossfightStatus = 3
	state = BossState.DEATH_STARS
	timer = 3
