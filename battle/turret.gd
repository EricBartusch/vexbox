extends Node2D

var health
var maxHealth
var speed = 666
var lifetime = 0.9
var velocity = Vector2.RIGHT * speed
var flipped = false

enum TurretState {
	LAUNCHING,
	LIVING,
	DYING
}

var state = TurretState.LAUNCHING
var turretBooletScene = load("res://battle/turretBoolet.tscn")

func _ready() -> void:
	health = get_parent().rng.randi_range(250, 300)
	maxHealth = health
	$TextureProgressBar.value = health
	$TextureProgressBar.max_value = health
	$TextureProgressBar/Label.text = str(health) + "/" + str(health)
	$TextureProgressBar.top_level = true

func _process(delta):
	if flashTimer > 0 and state != TurretState.DYING:
		flashTimer -= delta
		if flashTimer < 0:
			$Sprite2D.modulate = Color(1, 1, 1, 1)
	if !get_parent().lost and !get_parent().won and is_instance_valid(get_parent().boss) and get_parent().boss.health > 0 and get_parent().playerHealth > 0:
		match state:
			TurretState.LAUNCHING:
				position += velocity * delta
				if (position.y <= 200 or position.y >= 1720) and !flipped:
					flipped = true
					velocity.y *= -1
				velocity *= 0.995
				lifetime -= delta
				if lifetime <= 0:
					state = TurretState.LIVING
					lifetime = 1.5
					$TextureProgressBar.position = position
					$TextureProgressBar.position.y += 56
					$TextureProgressBar.position.x -= 79
					$TextureProgressBar.visible = true
			TurretState.LIVING:
				look_at(get_parent().protag.position)
				lifetime -= delta
				if lifetime <= 0:
					get_parent().get_node("OpenFXPlayer").play()
					lifetime = 1.5
					var new_bullet = turretBooletScene.instantiate()
					new_bullet.rotation = position.direction_to(get_parent().protag.position).angle()
					new_bullet.position = position
					new_bullet.velocity = new_bullet.velocity.rotated(new_bullet.rotation)
					get_parent().add_dakka(new_bullet)
			TurretState.DYING:
				position.x += vX * delta * 30
				position.y += vY * delta * 30
				vY += delta * 25
var flashTimer = 0

var vX
var vY

func _on_area_2d_area_entered(area: Area2D) -> void:
	if state != TurretState.DYING:
		if area.get_parent() is Bullet:
			get_parent().get_node("RevealFXPlayer").play()
			health -= get_parent().rng.randi_range(25, 50)
			$TextureProgressBar.value = health
			$TextureProgressBar/Label.text = str(health) + "/" + str(maxHealth)
			area.get_parent().get_parent().remove_child(area.get_parent())
			get_parent().update_boss_healthbar()
			flashTimer = 0.1
			$Sprite2D.modulate = Color(1, 1, 1, 0.6)
			if health <= 0:
				$Sprite2D.modulate = Color(1, 1, 1, 0.3)
				get_parent().get_node("KillTurretSoundPlayer").play()
				state = TurretState.DYING
				lifetime = 1
				vX = get_parent().rng.randf_range(-10, 10)
				vY = get_parent().rng.randf_range(-20, -6)
				$TextureProgressBar.visible = false
		elif area.get_parent() is Protag and (area.get_parent() as Protag).iframes <= 0:
			touch_protag(area)

func touch_protag(area):
	area.get_parent().get_parent().hurtPlayer()
