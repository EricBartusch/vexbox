extends Node2D

var SPEED = 2000
var timer = 5
var popupTimer
var spikedUp = false

func _ready() -> void:
	popupTimer = 3
	position.y = 2475

func _process(delta: float) -> void:
	timer -= delta
	if popupTimer > 0:
		popupTimer -= delta
		if popupTimer <= 0 and !spikedUp:
			get_parent().get_node("ShadowSpikeSoundPlayer").pitch_scale += 0.08
			get_parent().get_node("ShadowSpikeSoundPlayer").play()
	if popupTimer <= 0:
		if spikedUp:
			position.y += delta * SPEED
			if position.y >= 2425:
				get_parent().remove_child(self)
				queue_free()
		else:
			position.y -= delta * SPEED
			if position.y <= 1300:
				spikedUp = true
				popupTimer = 1.3


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Protag and (area.get_parent() as Protag).iframes <= 0:
		touch_protag(area)

func touch_protag(area):
	area.get_parent().get_parent().hurtPlayer()
		
