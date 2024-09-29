extends Area2D

@export var speed = 200 # velocidad de la bala
var direction = Vector2.UP

func _physics_process(delta):
	position += direction * speed * delta
	if position.y < 0:
		queue_free()

func _ready() -> void:
	$"000207126Prev".play()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Meteor") or body.is_in_group("EnemyShip") or body.is_in_group("sideShip") or body.is_in_group("Boss"):
		body.take_damage()
		queue_free()
	
