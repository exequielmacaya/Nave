extends CharacterBody2D

@export var speed = 100
@export var health = 2
@export var bullet_scene = preload("res://Bullet.tscn")
@export var shoot_cooldown = 0.2
var shoot_interval = 1.0  # Intervalo en segundos entre disparos
var time_since_last_shot = 0.0

var shoot_timer = 0.5

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

func shoot_bullet():
	# Instancia la bala
	var bullet = bullet_scene.instantiate()
	bullet.remove_from_group("bullet")
	bullet.add_to_group("Bullet_Enemy")
	bullet.position = position # la pos del player
	bullet.direction = Vector2.DOWN # va pa arriba
	get_parent().add_child(bullet) # aparece la bala
