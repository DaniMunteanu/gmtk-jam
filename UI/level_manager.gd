extends Control

@export var level_buttons: Array[TextureButton]

func _ready() -> void:
	level_buttons[0].disabled = false
	
	for level_index in range(1, LevelTracker.LEVELS_COUNT):
		level_buttons[level_index].disabled = not LevelTracker.levels_completed[level_index - 1]
		
	print(LevelTracker.levels_completed)
	
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level01.tscn")

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level02.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level03.tscn")

func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level04.tscn")

func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level05.tscn")

func _on_level_6_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level06.tscn")
