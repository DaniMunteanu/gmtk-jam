extends Node2D
class_name Level

@export var player: Player
@export var game_timer: Timer
#@onready var cam_player: AnimationPlayer = $Camera2D/AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var start_area: Area2D = $StartArea
@onready var hourglass_ui: HourglassUI = $CanvasLayer/HourglassUI

var die_cost: float = 25.0
var is_rewinding: bool = false

func _ready() -> void:
	hourglass_ui.sand_progress_up.max_value = game_timer.wait_time
	hourglass_ui.sand_progress_down.max_value = game_timer.wait_time
	
	Sceneswitcher.rewind.connect(_on_rewind)
	
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.1).timeout #2.0
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", player.camera.global_position, 6.0 )
	await get_tree().create_timer(0.1).timeout #6.0
	#cam_player.play("camera_pan")
	#await cam_player.animation_finished
	#cam_player.queue_free()
	camera.queue_free()
	process_mode = Node.PROCESS_MODE_INHERIT
	
	player.game_timer = game_timer
	for upgrade in player.upgrade_arr:
		if upgrade != null:
			upgrade.connect("reduce_time", game_timer_reduce)

#for debugging time
func _process(delta: float) -> void:
	player.player_ui.label.text = str(game_timer.time_left)
	hourglass_ui.update_sand(game_timer.time_left)
	#here connection with the progress bar


func _on_game_timer_timeout() -> void:
	print("ai pierdut!")
	#aici vine game over screen!
	get_tree().quit()


func _on_end_area_body_entered(body: Node2D) -> void:
	if body is Player:
		print("you won! goingto next lvl..")
		get_tree().change_scene_to_file("res://Levels/Level2.tscn")

func game_timer_reduce(time_cost: float):
	print("the cost is: ", time_cost)
	print("time you had before the upgrade: ", game_timer.time_left)
	if game_timer.time_left - time_cost > 0:
		game_timer.start(game_timer.time_left - time_cost)
	else:
		game_timer.stop()
		_on_game_timer_timeout()
	print("time you have after the upgrade: ", game_timer.time_left)

func _on_rewind():
	if is_rewinding: return
	is_rewinding = true
	print("REWIND TIME")
	player.hurtbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	game_timer_reduce(die_cost)
	process_mode = Node.PROCESS_MODE_DISABLED
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", 
	start_area.spawn_pos.global_position, 1.0)
	await get_tree().create_timer(1.1).timeout
	process_mode = Node.PROCESS_MODE_INHERIT
	player.hurtbox.get_node("CollisionShape2D").set_deferred("disabled", false)
	is_rewinding = false
