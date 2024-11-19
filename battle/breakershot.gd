extends Node2D

var speed = 750
var lifetime = 1.6
var velocity = Vector2.RIGHT * speed

var smallBoolet = preload("res://battle/bossshot.tscn")

func _process(delta):
	position += velocity * delta
	velocity *= 0.99
	lifetime -= delta
	if lifetime <= 0:
		for i in 9:
			var new_turret = smallBoolet.instantiate()
			new_turret.rotation = Vector2.LEFT.rotated(i*30).angle()
			new_turret.position = position
			new_turret.velocity = new_turret.velocity.rotated(new_turret.rotation)
			get_parent().add_dakka(new_turret)
		get_parent().get_node("TransmogFXPlayer").play()
		get_parent().remove_child(self)
		self.queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Protag and (area.get_parent() as Protag).iframes <= 0:
		touch_protag(area)

func touch_protag(area):
	area.get_parent().get_parent().hurtPlayer()
	get_parent().remove_dakka(self)
