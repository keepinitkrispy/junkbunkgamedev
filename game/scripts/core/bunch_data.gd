extends Node

# BunchData — singleton (autoload as "BunchData")
# Loads bunch_roster.json and provides stat lookups.

const ROSTER_PATH := "res://data/bunch/bunch_roster.json"

var _roster: Dictionary = {}   # id -> data dict

func _ready() -> void:
	var file := FileAccess.open(ROSTER_PATH, FileAccess.READ)
	if file == null:
		push_error("bunch_roster.json not found")
		return
	var parsed := JSON.parse_string(file.get_as_text())
	for entry in parsed.get("bunch", []):
		_roster[entry["id"]] = entry

func get_data(id: String) -> Dictionary:
	return _roster.get(id, {})

func cost(id: String) -> int:
	return _roster.get(id, {}).get("deploy_cost", 5)

func display_name(id: String) -> String:
	return _roster.get(id, {}).get("name", id)

func all_ids() -> Array:
	return _roster.keys()
