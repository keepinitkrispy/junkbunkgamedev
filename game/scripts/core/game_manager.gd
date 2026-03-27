extends Node

# GameManager — singleton (autoload as "GameManager")
# Owns top-level game state: current run, unlocks, scrap, phase.

signal scrap_changed(new_amount: int)
signal phase_changed(new_phase: Phase)
signal run_ended(victory: bool)

enum Phase { MENU, SQUAD_SELECT, WAVE, UPGRADE, BOSS, RUN_END }

const SAVE_PATH := "user://save.json"

# --- Persistent (survives runs) ---
var unlocked_bunch: Array[String] = ["boltz", "patchy", "scrapz"]
var junk_tokens: int = 0
var meta_upgrades: Dictionary = {
	"extra_starting_scrap": 0,
	"fourth_slot": false,
	"cost_reduction": 0,
}

# --- Run state (reset each run) ---
var current_phase: Phase = Phase.MENU
var scrap: int = 0
var squad: Array[String] = []        # up to 3 (or 4 with meta upgrade)
var current_world: String = ""
var current_wave: int = 0
var lives: int = 5

func _ready() -> void:
	load_save()

# ---- Phase control ----

func start_run(world: String) -> void:
	current_world = world
	current_wave = 0
	lives = 5
	scrap = 10 + meta_upgrades["extra_starting_scrap"]
	squad.clear()
	set_phase(Phase.SQUAD_SELECT)

func set_phase(p: Phase) -> void:
	current_phase = p
	phase_changed.emit(p)

# ---- Scrap ----

func add_scrap(amount: int) -> void:
	scrap += amount
	scrap_changed.emit(scrap)

func spend_scrap(amount: int) -> bool:
	var cost := max(0, amount - meta_upgrades["cost_reduction"])
	if scrap < cost:
		return false
	scrap -= cost
	scrap_changed.emit(scrap)
	return true

# ---- Lives ----

func lose_life() -> void:
	lives -= 1
	if lives <= 0:
		end_run(false)

func end_run(victory: bool) -> void:
	if victory:
		junk_tokens += 3
	else:
		junk_tokens += 1
	save_game()
	run_ended.emit(victory)
	set_phase(Phase.RUN_END)

# ---- Unlocks ----

func unlock_bunch_member(id: String) -> void:
	if id not in unlocked_bunch:
		unlocked_bunch.append(id)
		save_game()

func max_squad_size() -> int:
	return 4 if meta_upgrades["fourth_slot"] else 3

# ---- Save / Load ----

func save_game() -> void:
	var data := {
		"unlocked_bunch": unlocked_bunch,
		"junk_tokens": junk_tokens,
		"meta_upgrades": meta_upgrades,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_save() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var result := JSON.parse_string(file.get_as_text())
	if result == null:
		return
	unlocked_bunch = result.get("unlocked_bunch", unlocked_bunch)
	junk_tokens = result.get("junk_tokens", 0)
	meta_upgrades = result.get("meta_upgrades", meta_upgrades)
