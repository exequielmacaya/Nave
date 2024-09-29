extends Control

@onready var music_volume_slider = $MusicVolumeSlider
@onready var master_volume_slider = $MasterVolumeSlider
@onready var label_reasignar = $Label  # Label para mostrar la tecla que se va a reasignar

var esperando_tecla = false
var accion_a_reasignar = ""

func _ready():
	## Inicializar sliders con el volumen actual de los buses de audio
	
	var sonido_master= AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var slider_master=lerp(0,100,(sonido_master+80)/80)
	$master.value= slider_master


func _on_master_value_changed(value: float) -> void:
	var db_value = lerp(-80, 0, value/100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_value)


# Función para reasignar teclas
func _on_configurar_pressed(accion):
	esperando_tecla = true
	accion_a_reasignar = accion
	label_reasignar.text = "Presiona una nueva tecla para: " + accion

# Detectar cuando el jugador presiona una nueva tecla
#func _input(event):
	#if esperando_tecla and event is InputEventKey and event.pressed:
		## Eliminar la tecla anterior
		#InputMap.action_erase_events(accion_a_reasignar)
		## Asignar la nueva tecla
		#InputMap.action_add_event(accion_a_reasignar, event)
		#esperando_tecla = false
		#label_reasignar.text = accion_a_reasignar + " reasignada a la tecla: " + Input.get_key_name(event.physical_keycode)

func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")  # Volver al menú principal
