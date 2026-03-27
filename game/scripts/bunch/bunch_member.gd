extends Node2D
class_name BunchMember

# Base class for all Junk Bunch members.

signal died(member: BunchMember)

# --- Stats (override in child or set from BunchData) ---
@export var member_id: String = ""
@export var max_hp: int = 100
@export var attack_damage: int = 10
@export var attack_range: float = 40.0
@export var attack_speed: float = 1.0   # attacks per second
@export var deploy_cost: int = 5
@export var lane_index: int = 0

# --- Status effects ---
var is_slowed: bool = false
var is_stunned: bool = false
var is_glued: bool = false
var is_silenced: bool = false
var is_burning: bool = false

var _hp: int = 0
var _attack_timer: float = 0.0
var _current_target: Node2D = null

func _ready() -> void:
	_hp = max_hp
	add_to_group("bunch_members")

func _process(delta: float) -> void:
	if is_stunned or is_glued:
		return
	_find_target()
	if _current_target:
		_attack_timer += delta * (0.5 if is_slowed else 1.0)
		if _attack_timer >= 1.0 / attack_speed:
			_attack_timer = 0.0
			_do_attack()

func _find_target() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var closest: Node2D = null
	var closest_dist := attack_range

	for e in enemies:
		if e.lane_index != lane_index:
			continue
		var dist: float = abs(e.position.x - position.x)
		if dist <= closest_dist:
			closest_dist = dist
			closest = e

	_current_target = closest

func _do_attack() -> void:
	if _current_target and is_instance_valid(_current_target):
		_current_target.take_damage(attack_damage)

# Override in subclass for unique skill
func use_skill() -> void:
	if is_silenced:
		return

func take_damage(amount: int) -> void:
	var final_damage: int = amount * (2 if _is_weak_to_current_environment() else 1)
	_hp -= final_damage
	if _hp <= 0:
		_die()

# Override per character to define weakness conditions
func _is_weak_to_current_environment() -> bool:
	return false

func apply_status(effect: String, duration: float) -> void:
	match effect:
		"slow":
			is_slowed = true
			_clear_status_after("slow", duration)
		"stun":
			is_stunned = true
			_clear_status_after("stun", duration)
		"glue":
			is_glued = true
			_clear_status_after("glue", duration)
		"silence":
			is_silenced = true
			_clear_status_after("silence", duration)
		"burn":
			is_burning = true
			_burn_tick(duration)

func _clear_status_after(effect: String, duration: float) -> void:
	await get_tree().create_timer(duration).timeout
	match effect:
		"slow": is_slowed = false
		"stun": is_stunned = false
		"glue": is_glued = false
		"silence": is_silenced = false

func _burn_tick(remaining: float) -> void:
	if remaining <= 0 or not is_burning:
		is_burning = false
		return
	take_damage(3)
	await get_tree().create_timer(1.0).timeout
	_burn_tick(remaining - 1.0)

func _die() -> void:
	died.emit(self)
	WaveManager.notify_enemy_removed()
	queue_free()
