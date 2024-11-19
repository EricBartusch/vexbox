extends Node2D

var timer = 0
var speed = 1250
var velocity
var retreat = false

func fire(target):
	timer = 1.30
	velocity = (Vector2.RIGHT * speed).rotated(position.direction_to(get_parent().protag.position).angle())
	retreat = false

func _ready() -> void:
	$Sprite2D.modulate.a = 0

func _process(delta: float) -> void:
	if $Sprite2D.modulate.a < 1:
		$Sprite2D.modulate.a += delta * 10
	if get_parent().boss.health <= 0 and $Sprite2D.modulate.a >= 0:
		$Sprite2D.modulate.a -= delta * 12
	if timer > 0:
		timer -= delta
		if retreat:
			position -= velocity * delta
		else:
			position += velocity * delta
		if timer <= 0 and !retreat:
			retreat = true
			timer = 1.33
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Protag and (area.get_parent() as Protag).iframes <= 0:
		touch_protag(area)

func touch_protag(area):
	area.get_parent().get_parent().hurtPlayer()
