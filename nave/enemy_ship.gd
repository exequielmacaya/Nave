extends CharacterBody2D

@export var speed = 150
@export var health = 1

signal enemy_destroyed # señal de destruido

func _physics_process(delta):
	position.y += speed * delta

func take_damage():
	health -= 1
	if health <= 0:
		explode()

func explode():
	emit_signal("enemy_destroyed","enemy")
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
