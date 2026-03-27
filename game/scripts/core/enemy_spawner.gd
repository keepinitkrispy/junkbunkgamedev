extends Node

# EnemySpawner — singleton (autoload as "EnemySpawner")
# Loads enemy scenes by ID and places them in the correct lane.

const ENEMY_SCENE_PATH := "res://scenes/enemies/"
const LANE_START_X := 280.0

var _lane_manager: Node2D = null

func _ready() -> void:
	# Defer lookup so LaneManager has time to add itself to the group
	call_deferred("_find_lane_manager")

func _find_lane_manager() -> void:
	var nodes := get_tree().get_nodes_in_group("lane_manager")
	if nodes.size() > 0:
		_lane_manager = nodes[0] as Node2D

func spawn(enemy_id: String, lane: int) -> void:
	if _lane_manager == null:
		_find_lane_manager()
	if _lane_manager == null:
		push_error("EnemySpawner: LaneManager not found")
		return

	var scene_path := ENEMY_SCENE_PATH + enemy_id + ".tscn"
	if not ResourceLoader.exists(scene_path):
		push_error("Enemy scene not found: " + scene_path)
		return

	var scene: PackedScene = load(scene_path)
	var enemy: Node2D = scene.instantiate()
	var lane_node: Node2D = _lane_manager.call("get_lane_node", lane)
	lane_node.add_child(enemy)
	enemy.position.x = LANE_START_X
	enemy.set("lane_index", lane)
