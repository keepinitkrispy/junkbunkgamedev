extends CanvasLayer

# HUD — in-battle overlay.
# Top bar: wave, lives, scrap.
# Bottom bar: placed Bunch slots + skill button.
# Upgrade panel: shown between waves.

signal upgrade_chosen(upgrade_id: String)
signal skill_pressed(slot_index: int)

# Palette
const C_BAR_BG    := Color("1a1a2e")     # deep navy
const C_BAR_LINE  := Color("ff6b00")     # nickelodeon orange
const C_SCRAP     := Color("ffe600")     # cartoon yellow
const C_LIVES     := Color("ff2d55")     # hot pink-red
const C_WAVE      := Color("00b4ff")     # sky blue
const C_TEXT      := Color("fffde7")     # chalk white
const C_UPGRADE   := Color("7bc67e")     # slime green
const C_PANEL_BG  := Color("1a1a2e", 0.92)

@onready var _scrap_label: Label    = $TopBar/ScrapLabel
@onready var _lives_label: Label    = $TopBar/LivesLabel
@onready var _wave_label: Label     = $TopBar/WaveLabel
@onready var _upgrade_panel: Panel  = $UpgradePanel
@onready var _upgrade_list: VBoxContainer = $UpgradePanel/VBox/List

func _ready() -> void:
	GameManager.scrap_changed.connect(_on_scrap_changed)
	_upgrade_panel.visible = false
	_refresh_scrap(GameManager.scrap)

func _on_scrap_changed(amount: int) -> void:
	_refresh_scrap(amount)

func _refresh_scrap(amount: int) -> void:
	_scrap_label.text = "⚡ %d" % amount

func set_wave(wave_num: int) -> void:
	_wave_label.text = "Wave %d" % wave_num

func set_lives(lives: int) -> void:
	_lives_label.text = "♥ %d" % lives

func show_upgrade_panel() -> void:
	_upgrade_panel.visible = true
	_populate_upgrades()

func _populate_upgrades() -> void:
	for child in _upgrade_list.get_children():
		child.queue_free()

	var options := _generate_upgrade_options()
	for opt in options:
		var btn := _make_upgrade_button(opt)
		_upgrade_list.add_child(btn)

func _generate_upgrade_options() -> Array[Dictionary]:
	# TODO: pull from a proper upgrade pool
	return [
		{ "id": "scrap_boost",  "label": "+ 3 Scrap",           "desc": "Gain 3 Scrap now" },
		{ "id": "hp_boost",     "label": "All Bunch +20 HP",    "desc": "Heal and buff your squad" },
		{ "id": "speed_boost",  "label": "Attack Speed +25%",   "desc": "Your Bunch attacks faster this run" },
	]

func _make_upgrade_button(opt: Dictionary) -> Button:
	var btn := Button.new()
	btn.text = "%s\n%s" % [opt["label"], opt["desc"]]
	btn.custom_minimum_size = Vector2(180, 36)
	btn.pressed.connect(func():
		_upgrade_panel.visible = false
		upgrade_chosen.emit(opt["id"])
		_apply_upgrade(opt["id"])
		GameManager.set_phase(GameManager.Phase.WAVE)
	)
	return btn

func _apply_upgrade(id: String) -> void:
	match id:
		"scrap_boost":
			GameManager.add_scrap(3)
		"hp_boost":
			for m in get_tree().get_nodes_in_group("bunch_members"):
				m._hp = min(m._hp + 20, m.max_hp)
		"speed_boost":
			for m in get_tree().get_nodes_in_group("bunch_members"):
				m.attack_speed *= 1.25
