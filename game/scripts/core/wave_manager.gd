extends Node

# WaveManager — reads wave JSON and spawns enemies on a timer.

signal wave_started(wave_number: int)
signal wave_cleared(wave_number: int)
signal all_waves_cleared()

const WAVE_DATA_PATH := "res://data/waves/"

var _wave_data: Array = []
var _current_wave: int = 0
var _spawn_queue: Array = []
var _enemies_alive: int = 0
var _spawning: bool = false

@onready var _spawn_timer: Timer = $SpawnTimer

func load_world(world_id: String) -> void:
	var path := WAVE_DATA_PATH + world_id + ".json"
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Wave data not found: " + path)
		return
	var result := JSON.parse_string(file.get_as_text())
	_wave_data = result.get("waves", [])
	_current_wave = 0

func start_next_wave() -> void:
	if _current_wave >= _wave_data.size():
		all_waves_cleared.emit()
		return

	var wave: Dictionary = _wave_data[_current_wave]
	_spawn_queue = wave.get("spawns", []).duplicate()
	_enemies_alive = _spawn_queue.size()
	_spawning = true
	wave_started.emit(_current_wave + 1)
	_spawn_next()

func _spawn_next() -> void:
	if _spawn_queue.is_empty():
		_spawning = false
		return
	var entry: Dictionary = _spawn_queue.pop_front()
	_do_spawn(entry)
	if not _spawn_queue.is_empty():
		_spawn_timer.start(entry.get("delay", 1.0))

func _do_spawn(entry: Dictionary) -> void:
	var enemy_id: String = entry.get("enemy", "")
	var lane: int = entry.get("lane", 0)
	EnemySpawner.spawn(enemy_id, lane)

func _on_spawn_timer_timeout() -> void:
	_spawn_next()

# Called by each enemy when it dies or reaches the end.
func notify_enemy_removed() -> void:
	_enemies_alive -= 1
	if _enemies_alive <= 0 and not _spawning:
		_wave_cleared()

func _wave_cleared() -> void:
	wave_cleared.emit(_current_wave + 1)
	GameManager.add_scrap(5)
	_current_wave += 1
	GameManager.set_phase(GameManager.Phase.UPGRADE)
