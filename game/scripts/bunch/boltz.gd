extends BunchMember

# Boltz — old robot toy parts
# Skill: Magnetize — pulls all metal enemies in lane 2 tiles forward
# Weakness: short circuits in water (slowed + silenced when wet)

const MAGNET_RANGE := 80.0
const MAGNET_PULL := 16.0

func _ready() -> void:
	member_id = "boltz"
	max_hp = 120
	attack_damage = 12
	attack_range = 50.0
	attack_speed = 1.2
	deploy_cost = 6
	super._ready()

func use_skill() -> void:
	super.use_skill()
	var enemies := get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if e.lane_index != lane_index:
			continue
		if abs(e.position.x - position.x) <= MAGNET_RANGE:
			e.position.x -= MAGNET_PULL

func _is_weak_to_current_environment() -> bool:
	# Weak in pool or bathroom worlds
	return GameManager.current_world in ["backyard_pool", "bathroom"]
