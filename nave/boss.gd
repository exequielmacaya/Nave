extends CharacterBody2D

@export var speed = 100
@export var health = 8
@export var bullet_scene = preload("res://bullet_boss.tscn")
@export var shoot_cooldown = 1.5
@export var movimiento= Vector2()

signal  Boss_destroyed # señal de destruido

# Timer para controlar el disparo
@onready var shoot_timer = $ShootTimer

func _ready() -> void:
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))
	shoot_timer.start()


func _physics_process(delta):
	position.x += speed * delta
	#movimiento.x = speed  #esta coon el codigo de abajo hace que sigan de largo pero te miren
	#move_and_collide(movimiento * delta )
	#set_vector(get_node("../Player").global_position - global_position)
	#look_at(get_node("../Player").global_position)
	

func _on_shoot_timer_timeout() -> void:
	shoot_bullet()

func shoot_bullet() -> void:
	var bullet = bullet_scene.instantiate() # Crear una instancia de la bala
	bullet.position = position # Posición del boss
	#bullet.direction = Vector2.DOWN # Asigna la dirección de la bala 
	get_parent().add_child(bullet) # Añadir la bala a la escena

func set_vector(vector):
	movimiento = vector.normalized() * speed
	pass

var maxhealt = health * 1

func take_damage():
	health -= 1
	if health <= 0:
		explode()

func explosion():
	var explosion = preload("res://explosion.tscn").instantiate()
	get_parent().add_child(explosion)
	explosion.global_position=self.global_position + Vector2(randi()%210,randi()%210)
	explosion.scale=Vector2(0.25,0.25)




func explode():
	explosion()
	await get_tree().create_timer(1.5).timeout
	explosion()
	await get_tree().create_timer(1.5).timeout
	explosion()
	await get_tree().create_timer(1.5).timeout
	emit_signal("Boss_destroyed", "Boss") # Emite señal cuando se destruye
	queue_free()

func _on_rebote() -> void:
	speed = -speed
	pass
