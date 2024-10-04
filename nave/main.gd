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
@onready var next_level_label : Label = $NextLevelLabel  # Añadir un Label en la escena principal
@onready var level_timer : Timer = $LevelTimer  # Un Timer para mostrar el mensaje del siguiente nivel


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
	var screen_size = get_viewport_rect().size
	player.position = Vector2((screen_size.x ) / 2,  # Centro horizontal
		screen_size.y)  # Parte inferior de la pantalla
	# Añadimos al jugador a la escena principal
	add_child(player)
	pause_menu = preload("res://menu_pausa.tscn").instantiate()
	add_child(pause_menu)
	pause_menu.visible=false
	
	# Ocultar el Label del siguiente nivel inicialmente
	next_level_label.visible = false
	
	# Conectar señales timeout a las funciones correspondientes
	meteor_timer.timeout.connect(_on_MeteorTimer_timeout)
	enemy_timer.timeout.connect(_on_EnemyTimer_timeout)
	SideShip_timer.timeout.connect(_on_SideShipTimer_timeout)
	Boss_timer.timeout.connect(_on_BossTimer_timeout)
	level_timer.timeout.connect(_on_level_timer_timeout)  # Conectar el temporizador para el mensaje del siguiente nivel
	

	# Iniciar los timers)
	start_level (level)

func start_level(level):
	# Mostrar el cartel del siguiente nivel
	next_level_label.text = "Nivel " + str(level) + ": ¡Prepárate!"
	next_level_label.visible = true
	level_timer.start(3.0)  # Muestra el cartel durante 3 segundos

	# Pausa los timers de enemigos hasta que se oculta el mensaje
	meteor_timer.stop()
	enemy_timer.stop()
	SideShip_timer.stop()
	Boss_timer.stop()
	
func _on_level_timer_timeout():
	# Oculta el cartel y comeinza el nivel
	next_level_label.visible = false
	
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
	# Conecta la señal enemy_destroyed al Main
	meteor.meteor_destroyed.connect(self._on_enemy_destroyed)


func _on_EnemyTimer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf() * get_viewport_rect().size.x,0)
	add_child(enemy)
	enemy.enemy_destroyed.connect(self._on_enemy_destroyed)

func _on_SideShipTimer_timeout():
	var side_ship = side_ship_scene.instantiate()
	side_ship.position = Vector2(0 if randi()%2==1 else get_viewport_rect().size.x,randf() * get_viewport_rect().size.y)
	add_child(side_ship)
	side_ship.enemy_destroyed.connect(self._on_enemy_destroyed)
	
	
func _on_BossTimer_timeout():
# Verificar si ya hay un jefe en la escena
	if not get_node_or_null("Boss"):  # Si no hay un nodo llamado "Boss"
		var boss = boss_escene.instantiate()
		boss.position.x = randf() * get_viewport_rect().size.x
		#Vector2(randf() * get_viewport_rect().size.y, 0)
		add_child(boss)
		boss.Boss_destroyed.connect(self._on_enemy_destroyed)        
# Detiene el temporizador para que no siga generando más jefes
		Boss_timer.stop()


func _on_enemy_destroyed(enemy_type: String):
	match enemy_type:
		"meteor":
			meteor_count +=1
			$Pop.play()
		"enemy":
			enemy_count +=1
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
	
