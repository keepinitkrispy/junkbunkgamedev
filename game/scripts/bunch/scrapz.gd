extends BunchMember

# Scrapz — cardboard & duct tape
# Skill: Barricade — builds a temporary wall that blocks a lane for 5 seconds
# Weakness: burns (takes double damage from fire, dissolves in rain)

const WALL_HP := 60

func _ready() -> void:
	member_id = "scrapz"
	max_hp = 80
	attack_damage = 6
	attack_range = 30.0
	attack_speed = 1.5
	deploy_cost = 4
	super._ready()

func use_skill() -> void:
	super.use_skill()
	_spawn_wall()

func _spawn_wall() -> void:
	var wall := _build_wall_node()
	get_parent().add_child(wall)
	wall.position = Vector2(position.x + 20.0, 0.0)

func _build_wall_node() -> Node2D:
	var wall := Node2D.new()
	wall.name = "ScrapzWall"
	wall.add_to_group("bunch_members")

	# Wall script inline via lambda — acts as a simple HP blocker
	var wall_script := GDScript.new()
	wall_script.source_code = """
extends Node2D
var hp = %d
var lane_index = %d
func take_damage(amount):
	hp -= amount
	if hp <= 0: queue_free()
""" % [WALL_HP, lane_index]
	wall_script.reload()
	wall.set_script(wall_script)

	# Auto-destroy after 5 seconds even if not broken
	var timer := Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = true
	timer.timeout.connect(wall.queue_free)
	wall.add_child(timer)
	timer.start()

	return wall

func _is_weak_to_current_environment() -> bool:
	return GameManager.current_world in ["kitchen", "living_room", "office"]
