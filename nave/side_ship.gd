extends CharacterBody2D

@export var speed = 100
@export var health = 3
@export var movimiento= Vector2()

signal enemy_destroyed # señal de destruido

func _physics_process(delta):
	#position.x += speed * delta
	#movimiento.y = speed  esta coon el codigo de abajo hace que sigan de largo pero te miren
	move_and_collide(movimiento * delta )
	set_vector(get_node("../Player").global_position - global_position)
	look_at(get_node("../Player").global_position)
	
func set_vector(vector):
	movimiento = vector.normalized() * speed
	pass

func take_damage():
	health -= 1
	if health <= 0:
		explode()

func explode():
	emit_signal("enemy_destroyed","enemy")
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
