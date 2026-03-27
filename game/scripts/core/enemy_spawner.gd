extends Node

# EnemySpawner — singleton (autoload as "EnemySpawner")
# Loads enemy scenes by ID and places them in the correct lane.

const ENEMY_SCENE_PATH := "res://scenes/enemies/"

@onready var _lane_manager: Node2D = get_tree().get_first_node_in_group("lane_manager")

func spawn(enemy_id: String, lane: int) -> void:
	var scene_path := ENEMY_SCENE_PATH + enemy_id + ".tscn"
	if not ResourceLoader.exists(scene_path):
		push_error("Enemy scene not found: " + scene_path)
		return

	var scene: PackedScene = load(scene_path)
	var enemy: Node2D = scene.instantiate()
	var lane_node := _lane_manager.get_lane_node(lane)
	lane_node.add_child(enemy)
	enemy.position.x = LaneManager.LANE_START_X
	enemy.lane_index = lane
