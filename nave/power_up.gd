extends Area2D

#Para futuras implementaciones

func _on_PowerUp_body_entered(body):
	if body.is_in_group("Player"):
		apply_effect(body)
		queue_free()

func apply_effect(player):
	if is_in_group("SpeedBoost"):
		player.activate_speed_boost()
	elif is_in_group("DoubleShoot"):
		player.activate_double_shoot()
