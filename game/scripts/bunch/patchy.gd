extends BunchMember

# Patchy — sewn-together stuffed animals
# Skill: Stretch — attacks both adjacent lanes for 3 seconds
# Weakness: gets heavy when wet (half speed attack)

var _stretching: bool = false

func _ready() -> void:
	member_id = "patchy"
	max_hp = 150
	attack_damage = 8
	attack_range = 35.0
	attack_speed = 0.8
	deploy_cost = 5
	super._ready()

func use_skill() -> void:
	super.use_skill()
	if _stretching:
		return
	_stretching = true
	await get_tree().create_timer(3.0).timeout
	_stretching = false

func _do_attack() -> void:
	var targets := _get_targets()
	for t in targets:
		t.take_damage(attack_damage)

func _get_targets() -> Array:
	var result := []
	var lanes_to_hit := [lane_index]
	if _stretching:
		if lane_index > 0:
			lanes_to_hit.append(lane_index - 1)
		if lane_index < LaneManager.MAX_LANES - 1:
			lanes_to_hit.append(lane_index + 1)

	var enemies := get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if e.lane_index in lanes_to_hit:
			if abs(e.position.x - position.x) <= attack_range:
				result.append(e)
	return result

func _is_weak_to_current_environment() -> bool:
	return GameManager.current_world in ["backyard_pool", "bathroom", "yard"]
