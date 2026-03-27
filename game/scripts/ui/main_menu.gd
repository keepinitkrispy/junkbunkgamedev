extends Node2D

# MainMenu — title screen.

const C_BG_TOP    := Color("1a1a2e")
const C_BG_BOT    := Color("0d0d1a")
const C_ORANGE    := Color("ff6b00")
const C_YELLOW    := Color("ffe600")
const C_TEXT      := Color("fffde7")

@onready var _play_btn: Button   = $UI/VBox/PlayBtn
@onready var _title_lbl: Label   = $UI/VBox/TitleLabel
@onready var _sub_lbl: Label     = $UI/VBox/SubLabel

func _ready() -> void:
	_play_btn.pressed.connect(_on_play)

func _draw() -> void:
	# Gradient-ish background using two rects
	draw_rect(Rect2(0, 0, 320, 90),  C_BG_TOP)
	draw_rect(Rect2(0, 90, 320, 90), C_BG_BOT)
	# Orange accent stripe
	draw_rect(Rect2(0, 88, 320, 4), C_ORANGE)
	# Scattered junk dots for atmosphere
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 30:
		var x := rng.randf_range(0, 320)
		var y := rng.randf_range(0, 180)
		var r := rng.randf_range(1.0, 3.0)
		var col: Color = [C_ORANGE, C_YELLOW, Color("7bc67e"), Color("00b4ff")][rng.randi() % 4]
		col.a = rng.randf_range(0.2, 0.5)
		draw_circle(Vector2(x, y), r, col)

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/worlds/battle_scene.tscn")
