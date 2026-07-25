extends AnimatableBody2D

@export var start_marker: Marker2D
@export var end_marker: Marker2D
@export var duration: float = 2

func _ready() -> void:
	global_position = start_marker.global_position
	move()

func move():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "global_position", end_marker.global_position, duration)
	tween.tween_property(self, "global_position", start_marker.global_position, duration)
	
