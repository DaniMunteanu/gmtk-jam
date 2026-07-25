extends Node2D
class_name HourglassFinish

@export var camera: Camera2D
@export var next_level_path: String

@onready var sand_progress_up: TextureProgressBar = $SandProgressUp
@onready var sand_progress_down: TextureProgressBar = $SandProgressDown

@onready var sand_falling: AnimatedSprite2D = $SandFalling
@onready var cat: Sprite2D = $Cat

@onready var player_breaking_left: AnimatedSprite2D = $PlayerBreakingLeft
@onready var player_breaking_right: AnimatedSprite2D = $PlayerBreakingRight

signal level_won

func _ready() -> void:
	sand_falling.play()

func update_sand(time_left: float):
	sand_progress_up.value = time_left
	sand_progress_down.value = sand_progress_down.max_value - time_left
	cat.frame = int( sand_progress_down.value / (sand_progress_down.max_value / 9.0) ) % 9

func _on_victory_zone_left_body_entered(body: Node2D) -> void:
	if body is Player:
		level_won.emit()
		
		camera.make_current()
		camera.global_position = body.global_position
		
		body.hide()
		body.process_mode = Node.PROCESS_MODE_DISABLED
		
		# Move camera to hourglass
		var tween = create_tween()
		tween.tween_property(camera, "global_position", global_position, 1)
		
		player_breaking_left.visible = true
		player_breaking_left.play()
		print("you won! going to next lvl..")
		
		await player_breaking_left.animation_finished
		
		await get_tree().create_timer(2).timeout
		
		get_tree().change_scene_to_file(next_level_path)

func _on_victory_zone_right_body_entered(body: Node2D) -> void:
	if body is Player:
		level_won.emit()
		
		camera.make_current()
		camera.global_position = body.global_position
		
		body.hide()
		body.process_mode = Node.PROCESS_MODE_DISABLED
		
		# Move camera to hourglass
		var tween = create_tween()
		tween.tween_property(camera, "global_position", global_position, 1)
		
		player_breaking_right.visible = true
		player_breaking_right.play()
		print("you won! going to next lvl..")
		
		await player_breaking_right.animation_finished
		
		await get_tree().create_timer(2).timeout
		
		get_tree().change_scene_to_file(next_level_path)
