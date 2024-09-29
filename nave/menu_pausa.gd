extends Control

func _on_continuar_pressed():
	get_tree().paused = false  # Reanuda el juego
	get_parent().visible=false
	#queue_free()  # Cierra el menú de pausa

func _on_menu_principal_pressed():
	get_tree().paused = false  # Asegúrate de despausar antes de cambiar la escena
	get_tree().change_scene_to_file("res://menu_principal.tscn")  # Volver al menú principal

func on_menu_opciones_pressed():
	get_tree().paused= false
	get_tree().change_scene_to_file("res://menu_opciones.tscn") # va al menuprincipal



func _on_salida_pressed():
	get_tree().quit()  # Salir del juego
