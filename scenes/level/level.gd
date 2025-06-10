extends Node

signal input_captured(value: String)

var is_waiting_for_input := false

func _ready():
	var input_button = get_node("ui/button")
	input_button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("Waiting for input...")
	var input = await wait_for_user_input()
	print("User chose:", input)

func _input(event):
	if not is_waiting_for_input:
		return

	var result := ""
	if event is InputEventKey and event.pressed:
		result = event.as_text_keycode()
	elif event is InputEventMouseButton and event.pressed:
		result = "Mouse Button " + str(event.button_index)

	if result != "":
		is_waiting_for_input = false
		emit_signal("input_captured", result)

# Use a signal to await user input
func wait_for_user_input() -> String:
	is_waiting_for_input = true
	var result = await self.input_captured
	return result
		
func get_mouse_button_name(index: int) -> String:
	match index:
		1: return "Left Click"
		2: return "Right Click"
		3: return "Middle Click"
		4: return "Wheel Up"
		5: return "Wheel Down"
		6: return "Mouse Button 1"
		7: return "Mouse Button 2"
		8: return "Mouse Button 3"
		9: return "Mouse Button 4"
		10: return "Mouse Button 5"
		11: return "Mouse Button 6"
		12: return "Mouse Button 7"
		13: return "Mouse Button 8"
		14: return "Mouse Button 9"
		15: return "Mouse Button 10"
		_: return "Unknown Mouse Button"
