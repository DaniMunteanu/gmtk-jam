extends Upgrade

@export var speed_upgrade: float
@export var accel_upgrade: float


func power_up():
	print("UPGRADE 2 ACTIVE!")
	player.max_speed += speed_upgrade
	player.acceleration += accel_upgrade
	

func power_down():
	print("2 no more")
	player.max_speed -= speed_upgrade
	player.acceleration -= accel_upgrade
