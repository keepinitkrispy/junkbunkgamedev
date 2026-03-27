extends Node2D

func _draw() -> void:
	# Wall
	draw_rect(Rect2(0, 0, 320, 148), Color("f5f0dc"))
	# Chalkboard
	draw_rect(Rect2(7, 15, 90, 60), Color("5c3d1a"))
	draw_rect(Rect2(10, 18, 84, 54), Color("1a4a2e"))
	# Floor
	draw_rect(Rect2(0, 148, 320, 32), Color("8b6914"))
	# Lane dividers
	draw_line(Vector2(0, 105), Vector2(320, 105), Color(1, 1, 1, 0.2), 1)
	draw_line(Vector2(0, 62), Vector2(320, 62), Color(1, 1, 1, 0.2), 1)
