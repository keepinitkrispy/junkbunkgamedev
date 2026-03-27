extends CanvasLayer

# SquadSelect — shown before each run.
# Displays all unlocked Bunch members, lets player pick up to 3 (or 4).
# Confirms and calls battle_scene.on_squad_confirmed().

signal confirmed(squad: Array)

const C_BG       := Color("1a1a2e", 0.95)
const C_SELECTED := Color("ff6b00")
const C_NORMAL   := Color("fffde7", 0.15)
const C_TEXT     := Color("fffde7")
const C_COST     := Color("ffe600")

@onready var _grid: GridContainer     = $Panel/VBox/Grid
@onready var _confirm_btn: Button     = $Panel/VBox/ConfirmBtn
@onready var _squad_display: HBoxContainer = $Panel/VBox/SquadDisplay

var _selected: Array[String] = []

func _ready() -> void:
	_confirm_btn.pressed.connect(_on_confirm)
	_confirm_btn.disabled = true
	_populate_grid()
	GameManager.squad.clear()

func _populate_grid() -> void:
	for child in _grid.get_children():
		child.queue_free()

	for id in GameManager.unlocked_bunch:
		var data := BunchData.get_data(id)
		var btn := _make_member_button(id, data)
		_grid.add_child(btn)

func _make_member_button(id: String, data: Dictionary) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(60, 60)
	btn.tooltip_text = "%s\n%s\nCost: %d" % [
		data.get("name", id),
		data.get("skill", ""),
		data.get("deploy_cost", 5)
	]

	# Label inside button
	var lbl := Label.new()
	lbl.text = "%s\n⚡%d" % [data.get("name", id), data.get("deploy_cost", 5)]
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	btn.add_child(lbl)

	btn.pressed.connect(func(): _toggle_member(id, btn))
	return btn

func _toggle_member(id: String, btn: Button) -> void:
	if id in _selected:
		_selected.erase(id)
		btn.modulate = Color.WHITE
	else:
		if _selected.size() >= GameManager.max_squad_size():
			return
		_selected.append(id)
		btn.modulate = C_SELECTED

	_refresh_squad_display()
	_confirm_btn.disabled = _selected.is_empty()

func _refresh_squad_display() -> void:
	for child in _squad_display.get_children():
		child.queue_free()
	for id in _selected:
		var lbl := Label.new()
		lbl.text = BunchData.display_name(id)
		_squad_display.add_child(lbl)

func _on_confirm() -> void:
	GameManager.squad = _selected.duplicate()
	confirmed.emit(_selected.duplicate())
	get_parent().on_squad_confirmed()
