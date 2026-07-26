extends CanvasLayer

@export var start_scene_path : String
@export var credits_scene_path : String

@onready var options_panel = $OptionsPanel
@onready var button_manager: Control = $MenuScreen/ButtonManager
@onready var level_manager: Control = $MenuScreen/LevelManager

@onready var start: TextureButton = $MenuScreen/ButtonManager/Start
@onready var quit: TextureButton = $MenuScreen/ButtonManager/Quit

@onready var level1: TextureButton = $MenuScreen/LevelManager/Level1
@onready var level2: TextureButton = $MenuScreen/LevelManager/Level2
@onready var level3: TextureButton = $MenuScreen/LevelManager/Level3
@export var menu_music: AudioStream

func _ready() -> void:
	level_manager.visible = false
	_update_level_locks()

	AudioManager.play_music(menu_music)
func _update_level_locks() -> void:
	level1.disabled = false
	level2.disabled = true  # schimbă în true/false pe baza progresului real
	level3.disabled = true

func _on_start_pressed() -> void:
	button_manager.visible = false
	level_manager.visible = true

func _on_options_pressed() -> void:
	options_panel.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene_path)

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level01.tscn")

func _on_level_2_pressed() -> void:
	if not level2.disabled:
		get_tree().change_scene_to_file("res://Levels/Level02.tscn")

func _on_level_3_pressed() -> void:
	if not level3.disabled:
		get_tree().change_scene_to_file("res://Levels/level04.tscn")
