extends CanvasLayer

var _selected: Array[String] = []

func _ready() -> void:
	$Panel/VBox/ConfirmBtn.pressed.connect(_on_confirm)
	$Panel/VBox/ConfirmBtn.disabled = true
	GameManager.squad.clear()
	_populate_grid()

func _populate_grid() -> void:
	for child in $Panel/VBox/Grid.get_children():
		child.queue_free()
	for id in GameManager.unlocked_bunch:
		var data: Dictionary = BunchData.get_data(id)
		var btn := Button.new()
		btn.text = "%s\nCost:%d" % [data.get("name", id), data.get("deploy_cost", 5)]
		btn.custom_minimum_size = Vector2(60, 40)
		btn.pressed.connect(func(): _toggle(id, btn))
		$Panel/VBox/Grid.add_child(btn)

func _toggle(id: String, btn: Button) -> void:
	if id in _selected:
		_selected.erase(id)
		btn.modulate = Color.WHITE
	else:
		if _selected.size() >= GameManager.max_squad_size():
			return
		_selected.append(id)
		btn.modulate = Color.ORANGE
	$Panel/VBox/ConfirmBtn.disabled = _selected.is_empty()

func _on_confirm() -> void:
	GameManager.squad = _selected.duplicate()
	get_parent().on_squad_confirmed()
