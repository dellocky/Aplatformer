extends Node
var settings_node
var assignevent
func _ready() -> void:
	settings_node = get_node("data/settings")
	var value = settings_node.json_data["key"]

	if value.contains("MOUSE_BUTTON"):
		pass

	else:
		assignevent = InputEventKey.new()
		(assignevent as InputEventKey).set_keycode(
			OS.find_keycode_from_string(
				value
						)
					)
		(assignevent as InputEventKey).set_pressed(true)

	InputMap.action_erase_events(value)
	InputMap.action_add_event(value, assignevent)
	
func _process(_delta_time):
	if Input.is_action_pressed("key"):
		print("yep!")
	
