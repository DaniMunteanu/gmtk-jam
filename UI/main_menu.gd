extends CanvasLayer

@export var start_scene_path : String
@export var credits_scene_path : String

@onready var options_panel = $OptionsPanel
@onready var how_to_play_panel: Control = $HowToPlay

@onready var button_manager: Control = $MenuScreen/ButtonManager
@onready var level_manager: Control = $MenuScreen/LevelManager

@onready var start: TextureButton = $MenuScreen/ButtonManager/Start
@onready var quit: TextureButton = $MenuScreen/ButtonManager/Quit

@export var menu_music: AudioStream

func _ready() -> void:
	level_manager.visible = false

	AudioManager.play_music(menu_music)

func _on_start_pressed() -> void:
	button_manager.visible = false
	level_manager.visible = true

func _on_options_pressed() -> void:
	options_panel.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene_path)

func _on_how_to_play_pressed() -> void:
	how_to_play_panel.show()

func _on_close_pressed() -> void:
	button_manager.visible = true
	level_manager.visible = false
