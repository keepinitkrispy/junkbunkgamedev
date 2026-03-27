extends Node2D

@onready var _play_btn: Button = $UI/VBox/PlayBtn

func _ready() -> void:
	_play_btn.pressed.connect(_on_play)

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/worlds/battle_scene.tscn")
