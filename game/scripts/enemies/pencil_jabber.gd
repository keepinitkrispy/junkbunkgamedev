extends Enemy

# Pencil Jabber — fast, low HP, rapid stab

func _ready() -> void:
	enemy_id = "pencil_jabber"
	max_hp = 20
	move_speed = 30.0
	attack_damage = 5
	attack_speed = 2.0
	scrap_reward = 1
	super._ready()
