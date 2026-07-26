extends Upgrade

@export var shift_label: Label

var used_tp_once: bool = false

func power_up():
	if shift_label and used_tp_once == false:
		shift_label.show()
		used_tp_once = true
	player.can_tp = true

func power_down():
	if shift_label:
		shift_label.hide()
	player.can_tp = false
