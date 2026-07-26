extends Node2D
class_name Level

@export var level_index: int = 1

@export var player: Player
@export var game_timer: Timer
@export var win_path: String
@export var tilemap: TileMapLayer
#@onready var cam_player: AnimationPlayer = $Camera2D/AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var start_area: Area2D = $StartArea
@onready var hourglass_ui: HourglassUI = $CanvasLayer/HourglassUI
@onready var hourglass_finish: HourglassFinish = $HourglassFinish
@onready var rewind_texture: TextureRect = $CanvasLayer/TextureRect

@onready var defeat_screen: DefeatScreen = $CanvasLayer/DefeatScreen
@export var level_music: AudioStream
@export var game_over_music: AudioStream
#@export var heartbeat: AudioStream

var die_cost: float = 30.0
var is_rewinding: bool = false

var level_completed: bool = false
var level_lost: bool = false
var is_beating: bool = false

func _ready() -> void:
	player.anim_player.play("RESET")
	AudioManager.stop_gameover_music()
	AudioManager.play_music(level_music)
	set_cam_limits()
	hourglass_ui.sand_progress_up.max_value = game_timer.wait_time
	hourglass_ui.sand_progress_down.max_value = game_timer.wait_time
	
	hourglass_finish.sand_progress_up.max_value = game_timer.wait_time
	hourglass_finish.sand_progress_down.max_value = game_timer.wait_time
	
	hourglass_finish.level_won.connect(_on_level_won)
	
	hourglass_ui.update_sand(game_timer.time_left)
	hourglass_finish.update_sand(game_timer.time_left)
	
	rewind_texture.visible = false
	Sceneswitcher.rewind.connect(_on_rewind)
	
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(2).timeout #2.0
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", player.camera.global_position, 6.0 )
	await get_tree().create_timer(6).timeout #6.0
	#cam_player.play("camera_pan")
	#await cam_player.animation_finished
	#cam_player.queue_free()
	#camera.queue_free()
	
	player.camera.make_current()
	process_mode = Node.PROCESS_MODE_INHERIT
	
	player.game_timer = game_timer
	for upgrade in player.upgrade_arr:
		if upgrade != null:
			upgrade.connect("reduce_time", game_timer_reduce)

#for debugging time
func _process(delta: float) -> void:
	if  !game_timer.is_stopped() and game_timer.time_left <= 4.1 and !is_beating:
		player.heartbeat.play()
		is_beating = true
		print("BEAT")
	if level_completed == false:
		player.player_ui.label.text = str(game_timer.time_left)
		hourglass_ui.update_sand(game_timer.time_left)
		hourglass_finish.update_sand(game_timer.time_left)
		#here connection with the progress bar

func _on_level_won():
	LevelTracker.levels_completed[level_index - 1] = true
	level_completed = true
	game_timer.stop()
	await get_tree().create_timer(1).timeout
	player.glass_break.play()

func _on_game_timer_timeout() -> void:
	level_lost = true
	print("ai pierdut!")
	#aici vine game over screen!
	player.player_ui.hide()
	defeat_screen.show()
	
	player.hurt.play()
	AudioManager.stop_music()
	AudioManager.play_gameover_music(game_over_music)
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

"""
func _on_end_area_body_entered(body: Node2D) -> void:
	if body is Player:
		print("you won! goingto next lvl..")
		get_tree().change_scene_to_file("")
"""

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
	rewind_texture.visible = true
	player.anim_player.play("hit")
	player.rewind.play()
	is_rewinding = true
	print("REWIND TIME")
	player.hurtbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	game_timer_reduce(die_cost)
	await get_tree().create_timer(0.1).timeout
	process_mode = Node.PROCESS_MODE_DISABLED
	var tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", 
	start_area.spawn_pos.global_position, 1.5) # Ajustabil
	await get_tree().create_timer(1.6).timeout
	player.rewind.stop()
	
	if level_lost == false:
		process_mode = Node.PROCESS_MODE_INHERIT
		
	player.hurtbox.get_node("CollisionShape2D").set_deferred("disabled", false)
	is_rewinding = false
	rewind_texture.visible = false


func set_cam_limits():
	if !tilemap or !player:
		return
	var map_rect: Rect2i = tilemap.get_used_rect()
	var tile_size: Vector2i = tilemap.tile_set.tile_size
	
	var world_start: Vector2i = map_rect.position * tile_size
	var world_end: Vector2i = map_rect.end * tile_size
	
	player.camera.limit_left = world_start.x
	player.camera.limit_top = world_start.y
	player.camera.limit_right = world_end.x
	player.camera.limit_bottom = world_end.y
