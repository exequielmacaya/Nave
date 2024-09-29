extends Control


func _on_salir_pressed() -> void:
	get_tree().quit()  # Cierro el juego


func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn") 
