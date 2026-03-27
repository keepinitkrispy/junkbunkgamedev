extends CanvasLayer

@onready var _scrap_label: Label = $TopBar/ScrapLabel
@onready var _lives_label: Label = $TopBar/LivesLabel
@onready var _wave_label: Label  = $TopBar/WaveLabel

func _ready() -> void:
	GameManager.scrap_changed.connect(_on_scrap_changed)
	$UpgradePanel.visible = false

func _on_scrap_changed(amount: int) -> void:
	_scrap_label.text = "Scrap: %d" % amount

func set_wave(wave_num: int) -> void:
	_wave_label.text = "Wave %d" % wave_num

func set_lives(lives: int) -> void:
	_lives_label.text = "Lives: %d" % lives

func show_upgrade_panel() -> void:
	$UpgradePanel.visible = true
	_populate_upgrades()

func _populate_upgrades() -> void:
	for child in $UpgradePanel/VBox/List.get_children():
		child.queue_free()
	var options: Array[Dictionary] = [
		{ "id": "scrap_boost",  "label": "+ 3 Scrap" },
		{ "id": "hp_boost",     "label": "All Bunch +20 HP" },
		{ "id": "speed_boost",  "label": "Attack Speed +25%" },
	]
	for opt in options:
		var btn := Button.new()
		btn.text = opt["label"]
		btn.pressed.connect(func():
			$UpgradePanel.visible = false
			_apply_upgrade(opt["id"])
			GameManager.set_phase(GameManager.Phase.WAVE)
		)
		$UpgradePanel/VBox/List.add_child(btn)

func _apply_upgrade(id: String) -> void:
	if id == "scrap_boost":
		GameManager.add_scrap(3)
	elif id == "hp_boost":
		for m in get_tree().get_nodes_in_group("bunch_members"):
			m._hp = min(m._hp + 20, m.max_hp)
	elif id == "speed_boost":
		for m in get_tree().get_nodes_in_group("bunch_members"):
			m.attack_speed *= 1.25
