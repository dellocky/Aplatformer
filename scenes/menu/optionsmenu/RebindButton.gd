class_name RebindButton

extends Button
signal input_captured(value: String)
signal button_rebind(value: Array)

var action
var is_waiting_for_input := false

func _on_button_pressed():
	print("Waiting for input...")
	var input = await wait_for_user_input()
	print("User chose:", input)
	print([action, input])
	emit_signal("button_rebind", [str(action), str(input)])

func _input(event):
	if not is_waiting_for_input:
		return

	var result := ""
	if event is InputEventKey and event.pressed:
		result = event.as_text_keycode()
	elif event is InputEventMouseButton and event.pressed:
		result = get_mouse_button_name(event.button_index)

	if result != "":
		is_waiting_for_input = false
		emit_signal("input_captured", result)

# Use a signal to await user input
func wait_for_user_input() -> String:
	is_waiting_for_input = true
	var result = await self.input_captured
	return result
		
func get_mouse_button_name(index: int) -> String:
	var str_index = str(index)
	return "Mouse Button " + str_index

	
