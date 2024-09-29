extends Control

@export var splash_duration = 3.0  # Duración del splash screen en segundos

func _ready():
	await get_tree().create_timer(splash_duration).timeout  
	get_tree().change_scene_to_file("res://menu_principal.tscn") #Cambia a la escena del menú principal
