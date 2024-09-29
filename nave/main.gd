extends Node2D

@export var splash_escene : PackedScene 

# Exportar las escenas correctamente
@export var player_scene: PackedScene  
@export var meteor_scene : PackedScene
@export var enemy_scene : PackedScene
@export var powerup_scene : PackedScene
@export var side_ship_scene : PackedScene
@export var boss_escene: PackedScene



# Usamos 'onready' para obtener los nodos de Timer
@onready var meteor_timer : Timer = $MeteorTimer
@onready var enemy_timer : Timer = $EnemyTimer
@onready var SideShip_timer : Timer = $SideShipTimer
@onready var Boss_timer : Timer = $BossTimer


#var is_paused = false
var pause_menu
var meteor_count = 0
var enemy_count = 0
var level = 1
var total_kills = 0
var kills_to_next_level = 10

func _ready():
	
	# Instancio la escena del jugador
	var player = player_scene.instantiate()
	# Posiciono al jugador (ajusta la posición)
	player.position = Vector2(400, 400) 
	# Añadimos al jugador a la escena principal
	add_child(player)
	pause_menu = preload("res://menu_pausa.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.visible=false
	
	
	# Conectar señales timeout a las funciones correspondientes

	meteor_timer.timeout.connect(_on_MeteorTimer_timeout)
	enemy_timer.timeout.connect(_on_EnemyTimer_timeout)
	SideShip_timer.timeout.connect(_on_SideShipTimer_timeout)
	Boss_timer.timeout.connect(_on_BossTimer_timeout)

	# Iniciar los timers
	#meteor_timer.start()
	#enemy_timer.start()
	#SideShip_timer.start()
	#Boss_timer.start()
	start_level (level)

func start_level(level):
	match level:
		1:
			meteor_timer.start()
			enemy_timer.stop()
			SideShip_timer.stop()
		2: 
			meteor_timer.start()
			enemy_timer.start()
			SideShip_timer.stop()
		3:
			meteor_timer.start()
			enemy_timer.start()
			SideShip_timer.start()
		4:
			Boss_timer.start()
			meteor_timer.stop()
			enemy_timer.stop()
			SideShip_timer.stop()

	#spawn 
func _on_MeteorTimer_timeout():
	var meteor = meteor_scene.instantiate()
	meteor.position = Vector2(randf() * get_viewport_rect().size.x, 0)
	add_child(meteor)

	# Conectar la señal enemy_destroyed al Main
	meteor.meteor_destroyed.connect(self._on_enemy_destroyed)


func _on_EnemyTimer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf() * get_viewport_rect().size.x,0)
	add_child(enemy)
	enemy.enemy_destroyed.connect(self._on_enemy_destroyed)

func _on_SideShipTimer_timeout():
	var side_ship = side_ship_scene.instantiate()
	side_ship.position = Vector2(randf() * get_viewport_rect().size.y,0)
	add_child(side_ship)
	side_ship.enemy_destroyed.connect(self._on_enemy_destroyed)
	
func _on_BossTimer_timeout():
	var boss = boss_escene.instantiate()
	boss.position = Vector2(randf()*get_viewport_rect().size.y,0)
	add_child(boss)
	boss.Boss_destroyed.connect(self._on_enemy_destroyed)

func _on_enemy_destroyed(enemy_type: String):
	match enemy_type:
		"meteor":
			meteor_count +=1
			print(meteor_count)
			$Pop.play()
		"enemy":
			enemy_count +=1
			print(enemy_count)
		"Boss":
			get_tree().change_scene_to_file("res://creditos.tscn")
	total_kills +=1
	if total_kills>=kills_to_next_level:
		level+=1
		kills_to_next_level +=10
		start_level(level)
	

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):  # La tecla "Escape"
		if not pause_menu.visible:
			pause_game()
		else:
			unpause_game()

func pause_game():
	pause_menu.visible=true
	get_tree().paused = true  # Pausa el árbol de nodos


func unpause_game():
	pause_menu.visible=false
	get_tree().paused = false  # Reanuda el juego
	
