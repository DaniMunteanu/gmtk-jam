extends CanvasLayer

@onready var label: Label = $Label

@export_group("Upgrades")
@export var label_arr: Array[Label]
@export var btn_arr: Array[TextureButton]
@export var hourglass_arr: Array[Hourglass]
@export var active_timer_arr: Array[Timer]

@export var player: Player

func _ready() -> void:
	btn_arr[0].pressed.connect(press_one)
	btn_arr[1].pressed.connect(press_two)
	btn_arr[2].pressed.connect(press_three)
	
	for glass in hourglass_arr:
		glass.hide()
	#hiding the hourglasses at the beginning

func _process(delta: float) -> void:
	for timer in active_timer_arr:
		if !timer.is_stopped():
			#print("this timer: ", timer, "is going!")
			hourglass_arr[active_timer_arr.find(timer)].update_sand(timer.time_left)

func hide_upgrade_butt(upgrade_no: int, active_timer: Timer):
	hourglass_arr[upgrade_no - 1].progress_up.max_value = active_timer.wait_time
	hourglass_arr[upgrade_no - 1].progress_down.max_value = active_timer.wait_time
	
	label_arr[upgrade_no - 1].visible = false
	hourglass_arr[upgrade_no -1].show()
	
	#and show the blue hourglass
	
func greybutt(upgrade_no: int):
	label_arr[upgrade_no - 1].visible = true
	label_arr[upgrade_no - 1].self_modulate.a = 0.2
	hourglass_arr[upgrade_no -1].hide()
	#for now, it just returns the label
	#hide the hourglass, show the grey btn

func show_butt(upgrade_no: int):
	label_arr[upgrade_no - 1].self_modulate.a = 1.0
	
func press_one():
	player.activate_upgrade(0)
	
func press_two():
	player.activate_upgrade(1)
	
func press_three():
	player.activate_upgrade(2)
