extends Node2D

# BattleScene — orchestrates one world's combat.
# Owns the LaneManager and WaveManager, reacts to GameManager phase changes.

@onready var lane_manager: Node2D       = $LaneManager
@onready var wave_manager: Node        = $WaveManager
@onready var hud: CanvasLayer          = $HUD
@onready var squad_select: CanvasLayer = $SquadSelect
@onready var phase_overlay: ColorRect  = $PhaseOverlay

var _world_id: String = "classroom"

func _ready() -> void:
	GameManager.phase_changed.connect(_on_phase_changed)
	GameManager.run_ended.connect(_on_run_ended)
	wave_manager.wave_started.connect(_on_wave_started)
	wave_manager.wave_cleared.connect(_on_wave_cleared)
	wave_manager.all_waves_cleared.connect(_on_all_waves_cleared)

	wave_manager.load_world(_world_id)
	GameManager.start_run(_world_id)

func _on_phase_changed(phase: GameManager.Phase) -> void:
	match phase:
		GameManager.Phase.SQUAD_SELECT:
			squad_select.visible = true
			hud.visible = false
		GameManager.Phase.WAVE:
			squad_select.visible = false
			hud.visible = true
			wave_manager.start_next_wave()
		GameManager.Phase.UPGRADE:
			hud.show_upgrade_panel()
		GameManager.Phase.RUN_END:
			pass

func _on_wave_started(wave_num: int) -> void:
	hud.set_wave(wave_num)

func _on_wave_cleared(_wave_num: int) -> void:
	pass  # GameManager already moved to UPGRADE phase

func _on_all_waves_cleared() -> void:
	GameManager.end_run(true)

func _on_run_ended(victory: bool) -> void:
	phase_overlay.color = Color(0, 0.6, 0, 0.5) if victory else Color(0.6, 0, 0, 0.5)
	phase_overlay.visible = true
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

# Called by SquadSelect when the player confirms their squad
func on_squad_confirmed() -> void:
	GameManager.set_phase(GameManager.Phase.WAVE)
