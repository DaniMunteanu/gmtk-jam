extends Node
class_name Upgrade

@export var player: Player
@export var cooldown_timer: Timer
@export var active_timer: Timer
@export var time_price: float
@export var self_no: int
signal reduce_time(time_price: float)
var is_active: bool = false
var is_on_cooldown: bool = false
#signal show_glass_hide_butt(no: int)
#signal hide_glass_show_greybutt(no: int)
#signal full_butt(no: int)


func _ready() -> void:
	active_timer.timeout.connect(_on_active_timer_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func activate():
	if !is_on_cooldown and !is_active:
		print("UPGRADE ACTIVATED!")
		reduce_time.emit(time_price)
		is_active = true
		power_up()
		active_timer.start()
		player.player_ui.hide_upgrade_butt(self_no)
		#aici dispare butonul si apare clepsidra albastra
		

func _on_active_timer_timeout() -> void:
	is_active = false
	power_down()
	print("not active anymore!")
	if !is_on_cooldown:
		is_on_cooldown = true
		cooldown_timer.start()
	player.player_ui.greybutt(self_no)
	#aici apare inapoi butonul doar ca greyed out


func _on_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
	print('not on cooldown anymore!')
	#aici e butonul din nou full opacity
	player.player_ui.show_butt(self_no)

func power_up(): pass
func power_down(): pass
