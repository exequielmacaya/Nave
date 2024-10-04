extends CharacterBody2D

@export var speed = 150
@export var health = 1
@export var bullet_scene = preload("res://Bullet.tscn")
@export var shoot_cooldown = 0.2
var shoot_interval = 1.0  # Intervalo en segundos entre disparos
var time_since_last_shot = 0.0

var shoot_timer = 0.5

signal enemy_destroyed # señal de destruido

func _ready():
	# Inicializar variables si es necesario
	time_since_last_shot = 0.0

func _process(delta):
	# Incrementar el tiempo desde el último disparo
	time_since_last_shot += delta 
	# Verificar si ha pasado el intervalo de disparo
	if time_since_last_shot >= shoot_interval:
		shoot_bullet()  # Disparar proyectil
		time_since_last_shot = 0.0  # Reiniciar el tiempo

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
	bullet.position = position # la pos del player
	bullet.direction = Vector2.DOWN # va pa arriba
	get_parent().add_child(bullet) # aparece la bala
