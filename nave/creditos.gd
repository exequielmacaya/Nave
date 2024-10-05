extends Control

@export var scroll_speed = 50.0  # Velocidad de scroll en píxeles por segundo

func _ready():
	# Obtener el tamaño de la pantalla
	var screen_size = get_viewport_rect().size
	
	# Obtener el tamaño del Label (para centrarlo)
	var label_size = $Label.get_minimum_size()
	
	# Alinea el Label horizontalmente en el centro y colocarlo fuera de la pantalla en la parte inferior
	$Label.position = Vector2(
		(screen_size.x - label_size.x) / 2,  # Centro horizontal
		screen_size.y  # Parte inferior de la pantalla
	)
	
	# Texto de créditos
	$Label.text = """Créditos:
	Desarrolladores: 
		- Macaya, Exequiel
		- Sanhueza, Marianela
		- Fernández, Lucas Damián
		- Agustina
		
	Equipo Docente:
		- Sastre Arriola, Néstor Ubaldo
		- Pintos, Micaela Luján
		
	Música:
		-Creedence Clearwater Revival: Fortunate son: Version tiktok por Fringster.com
		-efectos de sonidos: Fringter.com
	Imagenes
		-pngwing.com
		

	"""

func _process(delta):
	# Mover el Label de créditos hacia arriba
	$Label.position.y -= scroll_speed * delta

	# Obtener el tamaño mínimo del Label
	var label_size = $Label.get_minimum_size()
	
	# Verificar si el Label se ha desplazado completamente fuera de la pantalla
	if $Label.position.y + label_size.y < 0:
		get_tree().change_scene_to_file("res://menu_principal.tscn")
