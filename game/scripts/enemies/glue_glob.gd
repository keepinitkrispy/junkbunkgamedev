extends Enemy

# Glue Glob — immobilizes Bunch members on contact, low HP

const GLUE_DURATION := 3.0

func _ready() -> void:
	enemy_id = "glue_glob"
	max_hp = 25
	move_speed = 12.0
	attack_damage = 2
	attack_speed = 0.4
	scrap_reward = 2
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	_check_glue_contact()

func _check_glue_contact() -> void:
	var members := get_tree().get_nodes_in_group("bunch_members")
	for m in members:
		if m.lane_index == lane_index and abs(m.position.x - position.x) <= 8.0:
			m.apply_status("glue", GLUE_DURATION)
