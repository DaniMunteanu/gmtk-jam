extends Control
class_name Hourglass


@export var progress_up: TextureProgressBar
@export var progress_down: TextureProgressBar


func update_sand(time_left: float):
	progress_up.value = time_left
	progress_down.value = progress_down.max_value - time_left



#useless, just use show() and make sure
#the progress bars are themselves visible but the root node is hidden
func show_hourglass():
	progress_up.visible = true
	progress_down.visible = true
