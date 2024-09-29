extends CharacterBody2D

#shader de roptura de los meteoritos
@export var speed = 100
@export var health = 2

signal  meteor_destroyed # señal de destruido

func _physics_process(delta):
	position.y += speed * delta
	rotate(rotationspeed * delta)
	if Input.is_action_just_pressed("ui_end"):
		explode()

var maxhealt 
var rotationspeed

func _ready() -> void:
	maxhealt = health
	rotationspeed = randf_range(PI/8,PI/2)

func take_damage():
	health -= 1
	if health <= 0:
		explode()
	modulate = Color(1,float(health)/maxhealt,float(health)/maxhealt)


func explode():
	emit_signal("meteor_destroyed","meteor") #emite señal cuando se destruye
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
