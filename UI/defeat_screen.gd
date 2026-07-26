extends Control
class_name DefeatScreen

@export var level_path: String = ""

func _ready() -> void:
	hide()

func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file(level_path)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
