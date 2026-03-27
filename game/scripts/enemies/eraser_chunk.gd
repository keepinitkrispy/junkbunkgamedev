extends Enemy

# Eraser Chunk — lobs itself, leaves dust cloud on death (blinds nearby Bunch)

const BLIND_DURATION := 2.5
const BLIND_RADIUS := 30.0

func _ready() -> void:
	enemy_id = "eraser_chunk"
	max_hp = 30
	move_speed = 18.0
	attack_damage = 8
	attack_speed = 0.6
	scrap_reward = 2
	super._ready()

func _die() -> void:
	_spawn_dust_cloud()
	super._die()

func _spawn_dust_cloud() -> void:
	var members := get_tree().get_nodes_in_group("bunch_members")
	for m in members:
		if abs(m.global_position.x - global_position.x) <= BLIND_RADIUS \
		and m.lane_index == lane_index:
			m.apply_status("stun", BLIND_DURATION)
