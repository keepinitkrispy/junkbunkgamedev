extends Node2D

# LaneManager — owns the lane grid.
# Lanes run left (enemy spawn) to right (Bunch side / home base).

signal bunch_placed(member_id: String, lane: int)
signal enemy_reached_end(lane: int)

const MAX_LANES := 5
const LANE_HEIGHT := 32   # pixels between lane centres
const LANE_START_X := 280 # enemy spawn X
const LANE_END_X := 16    # home base X

@export var lane_count: int = 3

var _lanes: Array = []   # Array of lane node references

func _ready() -> void:
	add_to_group("lane_manager")
	_build_lanes()

func _build_lanes() -> void:
	_lanes.clear()
	for i in lane_count:
		var lane := _make_lane(i)
		add_child(lane)
		_lanes.append(lane)

func _make_lane(index: int) -> Node2D:
	var lane := Node2D.new()
	lane.name = "Lane%d" % index
	lane.position.y = _lane_y(index)
	return lane

func lane_y(index: int) -> float:
	return _lane_y(index)

func _lane_y(index: int) -> float:
	var total_height := (lane_count - 1) * LANE_HEIGHT
	var top := (180.0 - total_height) / 2.0
	return top + index * LANE_HEIGHT

func get_lane_node(index: int) -> Node2D:
	return _lanes[index]

# Called by input handler when player taps a lane to place a member.
func try_place_bunch(member_id: String, lane: int) -> bool:
	if lane < 0 or lane >= lane_count:
		return false
	if not GameManager.spend_scrap(BunchData.cost(member_id)):
		return false
	bunch_placed.emit(member_id, lane)
	return true

# Called by enemies when they reach X <= LANE_END_X.
func notify_enemy_reached_end(lane: int) -> void:
	enemy_reached_end.emit(lane)
	GameManager.lose_life()
