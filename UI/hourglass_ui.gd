extends Control
class_name HourglassUI

@onready var sand_falling: AnimatedSprite2D = $SandFalling

@onready var sand_progress_up: TextureProgressBar = $SandProgressUp
@onready var sand_progress_down: TextureProgressBar = $SandProgressDown

func _ready() -> void:
	sand_falling.play()

func update_sand(time_left: float):
	sand_progress_up.value = time_left
	sand_progress_down.value = sand_progress_down.max_value - time_left
