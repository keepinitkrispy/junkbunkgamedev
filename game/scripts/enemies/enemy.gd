extends Node2D
class_name Enemy

# Base class for all enemies.

signal died(enemy: Enemy)

@export var enemy_id: String = ""
@export var max_hp: int = 50
@export var move_speed: float = 20.0   # pixels per second (moves left)
@export var attack_damage: int = 10
@export var attack_speed: float = 0.5  # attacks per second
@export var scrap_reward: int = 2
@export var lane_index: int = 0

var _hp: int = 0
var _attack_timer: float = 0.0
var _current_target: Node2D = null
var _blocked: bool = false

# Status flags
var is_slowed: bool = false
var is_stunned: bool = false

func _ready() -> void:
	_hp = max_hp
	add_to_group("enemies")

func _process(delta: float) -> void:
	if is_stunned:
		return

	_find_target()

	if _current_target:
		_blocked = true
		_attack_timer += delta
		if _attack_timer >= 1.0 / attack_speed:
			_attack_timer = 0.0
			_current_target.take_damage(attack_damage)
	else:
		_blocked = false
		var speed := move_speed * (0.5 if is_slowed else 1.0)
		position.x -= speed * delta
		if position.x <= LaneManager.LANE_END_X:
			_reach_end()

func _find_target() -> void:
	var members := get_tree().get_nodes_in_group("bunch_members")
	_current_target = null
	for m in members:
		if m.lane_index != lane_index:
			continue
		if m.position.x >= position.x - 4.0:
			_current_target = m
			break

func take_damage(amount: int) -> void:
	_hp -= amount
	if _hp <= 0:
		_die()

func apply_status(effect: String, duration: float) -> void:
	match effect:
		"slow":
			is_slowed = true
			_clear_after("slow", duration)
		"stun":
			is_stunned = true
			_clear_after("stun", duration)

func _clear_after(effect: String, duration: float) -> void:
	await get_tree().create_timer(duration).timeout
	match effect:
		"slow": is_slowed = false
		"stun": is_stunned = false

func _reach_end() -> void:
	LaneManager.notify_enemy_reached_end(lane_index)
	WaveManager.notify_enemy_removed()
	queue_free()

func _die() -> void:
	GameManager.add_scrap(scrap_reward)
	died.emit(self)
	WaveManager.notify_enemy_removed()
	queue_free()
