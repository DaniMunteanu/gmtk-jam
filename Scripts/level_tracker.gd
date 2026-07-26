extends Node

const LEVELS_COUNT = 6
var levels_completed: Array[bool]

func _ready() -> void:
	levels_completed.resize(LEVELS_COUNT)
	levels_completed.fill(false)
