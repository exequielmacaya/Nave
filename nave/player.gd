extends CharacterBody2D

@export var speed = 200
@export var bullet_scene = preload("res://Bullet.tscn")
@export var shoot_cooldown = 0.4
@export var health = 3
@onready var shoot: AudioStreamPlayer2D = $Player/Shoot

var shoot_timer = 0.5
var double_shoot = false

func _physics_process(delta):
	handle_movement(delta)
	handle_shooting(delta)

func handle_movement(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1

	# Normalizamos la velocidad y ajustamos según la speed
	velocity = velocity.normalized() * speed

	# Asignamos la velocidad al CharacterBody2D
	self.velocity = velocity
	move_and_slide()

# Maneja el disparo
func handle_shooting(delta):
	shoot_timer -= delta
	if Input.is_action_pressed("ui_shoot") and shoot_timer <= 0:
		shoot_bullet()
		shoot_timer = shoot_cooldown

func shoot_bullet():
	# Instancia la bala
	var bullet = bullet_scene.instantiate()
	bullet.position = position # la pos del player
	bullet.direction = Vector2.UP # va pa arriba
	get_parent().add_child(bullet) # aparece la bala
	# para el doble tiro
	shoot.play()

# Power-ups
func activate_speed_boost():
	speed += 200

func activate_double_shoot():
	double_shoot = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Meteor") or body.is_in_group("EnemyShip") or body.is_in_group("sideShip") or body.is_in_group("Boss") :
		body.explode()
		take_damage()

func take_damage():
	get_tree().get_nodes_in_group("barravidaplayer")[0].DisminuirVida(1)
	health -= 1
	if health <= 0:
		explode()

func explode():
	#queue_free()
	get_tree().change_scene_to_file("res://menu_derrota.tscn")
