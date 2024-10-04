extends  Area2D

@export var speed = 150 # velocidad de la bala
@export var movimiento= Vector2()

var direction = Vector2.DOWN

func _physics_process(delta):
	#position.x += speed * delta
	movimiento.y = speed  #esta coon el codigo de abajo hace que sigan de largo pero te miren
	position+=(movimiento * delta )
	set_vector(get_node("../Player").global_position - global_position)
	#look_at(get_node("../Player").global_position)
	
	
func set_vector(vector):
	movimiento = vector.normalized() * speed
	pass
	

	if position.y < 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage()
		queue_free()
