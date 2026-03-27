extends Node2D

# ClassroomBackground — draws the classroom environment procedurally.
# Uses our style guide palette: chalk white, deep blue, orange accent.
# Replace draw calls with real sprite sheets once art is ready.

# Palette
const C_WALL        := Color("f5f0dc")   # warm chalk white walls
const C_FLOOR       := Color("8b6914")   # wooden floor brown
const C_BOARD       := Color("1a4a2e")   # deep chalkboard green
const C_BOARD_FRAME := Color("5c3d1a")   # wooden frame
const C_DESK        := Color("c4973a")   # desk wood
const C_DESK_DARK   := Color("8b6914")   # desk shadow
const C_WINDOW      := Color("aaddff")   # window sky blue
const C_LINE        := Color("ffffff", 0.15)  # chalk lane lines
const C_STRIPE      := Color("ffffff", 0.04)  # wall stripe subtle

# Layout constants
const FLOOR_Y      := 148.0
const BOARD_X      := 4.0
const BOARD_Y      := 18.0
const BOARD_W      := 90.0
const BOARD_H      := 60.0

func _draw() -> void:
	_draw_wall()
	_draw_windows()
	_draw_chalkboard()
	_draw_floor()
	_draw_desks()
	_draw_lane_lines()
	_draw_chalk_dust()

func _draw_wall() -> void:
	draw_rect(Rect2(0, 0, 320, FLOOR_Y), C_WALL)
	# subtle horizontal wall stripes
	for i in range(0, int(FLOOR_Y), 12):
		draw_line(Vector2(0, i), Vector2(320, i), C_STRIPE, 1.0)

func _draw_windows() -> void:
	# Two windows on the right side of the wall
	var windows := [Vector2(220, 22), Vector2(272, 22)]
	for w in windows:
		# Frame
		draw_rect(Rect2(w.x - 2, w.y - 2, 36, 50), C_DESK_DARK)
		# Glass
		draw_rect(Rect2(w.x, w.y, 32, 46), C_WINDOW)
		# Cross pane
		draw_line(Vector2(w.x + 16, w.y), Vector2(w.x + 16, w.y + 46), C_DESK_DARK, 1.5)
		draw_line(Vector2(w.x, w.y + 23), Vector2(w.x + 32, w.y + 23), C_DESK_DARK, 1.5)
		# Shine
		draw_rect(Rect2(w.x + 2, w.y + 2, 6, 10), Color(1, 1, 1, 0.3))

func _draw_chalkboard() -> void:
	# Wooden frame
	draw_rect(Rect2(BOARD_X - 3, BOARD_Y - 3, BOARD_W + 6, BOARD_H + 6), C_BOARD_FRAME)
	# Board surface
	draw_rect(Rect2(BOARD_X, BOARD_Y, BOARD_W, BOARD_H), C_BOARD)
	# Chalk title text placeholder lines
	draw_line(
		Vector2(BOARD_X + 8, BOARD_Y + 14),
		Vector2(BOARD_X + BOARD_W - 8, BOARD_Y + 14),
		Color(1, 1, 1, 0.6), 2.0
	)
	for i in range(3):
		var ly := BOARD_Y + 26 + i * 10
		draw_line(
			Vector2(BOARD_X + 6, ly),
			Vector2(BOARD_X + BOARD_W - 6, ly),
			Color(1, 1, 1, 0.25), 1.0
		)
	# Chalk tray
	draw_rect(Rect2(BOARD_X, BOARD_Y + BOARD_H, BOARD_W, 4), C_BOARD_FRAME)
	draw_rect(Rect2(BOARD_X + 4, BOARD_Y + BOARD_H + 1, 8, 2), Color(1, 1, 1, 0.8))

func _draw_floor() -> void:
	# Floor base
	draw_rect(Rect2(0, FLOOR_Y, 320, 180 - FLOOR_Y), C_FLOOR)
	# Floor planks
	for i in range(0, 320, 20):
		draw_line(Vector2(i, FLOOR_Y), Vector2(i, 180), C_DESK_DARK, 1.0)
	# Floor highlight at wall join
	draw_line(Vector2(0, FLOOR_Y), Vector2(320, FLOOR_Y), Color(1, 1, 1, 0.3), 1.5)

func _draw_desks() -> void:
	# Background desks — decorative only, behind lanes
	var desk_positions := [
		Vector2(108, 108), Vector2(148, 108), Vector2(188, 108),
		Vector2(128, 128), Vector2(168, 128), Vector2(208, 128),
	]
	for d in desk_positions:
		# Desk top
		draw_rect(Rect2(d.x, d.y, 30, 16), C_DESK)
		# Desk shadow/leg
		draw_rect(Rect2(d.x + 2, d.y + 16, 26, 4), C_DESK_DARK)

func _draw_lane_lines() -> void:
	# Subtle dashed lane dividers
	var lane_ys := [74.0, 106.0]   # between lanes 0-1 and 1-2
	for ly in lane_ys:
		var x := 0.0
		while x < 320:
			draw_line(Vector2(x, ly), Vector2(x + 8, ly), C_LINE, 1.0)
			x += 14.0

func _draw_chalk_dust() -> void:
	# Tiny chalk dust dots near the board for atmosphere
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	for i in range(20):
		var dx := rng.randf_range(BOARD_X, BOARD_X + BOARD_W)
		var dy := rng.randf_range(BOARD_Y + BOARD_H + 2, BOARD_Y + BOARD_H + 10)
		draw_circle(Vector2(dx, dy), rng.randf_range(0.5, 1.5), Color(1, 1, 1, 0.4))
