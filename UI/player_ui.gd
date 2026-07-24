extends CanvasLayer

@onready var label: Label = $Label

@export_group("Upgrades")
@export var label_arr: Array[Label]
@export var btn_arr: Array[TextureButton]
@export var upgrade_arr: Array[Upgrade]


func _ready() -> void:
	pass


func hide_upgrade_butt(upgrade_no: int):
	label_arr[upgrade_no - 1].visible = false
	#and show the blue hourglass
	
func greybutt(upgrade_no: int):
	label_arr[upgrade_no - 1].visible = true
	label_arr[upgrade_no - 1].self_modulate.a = 0.2
	#for now, it just returns the label
	#hide the hourglass, show the grey btn

func show_butt(upgrade_no: int):
	label_arr[upgrade_no - 1].self_modulate.a = 1.0
