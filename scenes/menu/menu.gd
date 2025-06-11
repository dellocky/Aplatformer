extends Node


# Preload the scene (this is faster and better for small projects)
var OptionsMenuScene := preload("res://scenes/menu/optionsmenu/optionsmenu.tscn")
@onready var settings_node := get_node("data/settings")
@onready var signal_settings := get_node("signal_control/signal_settings")
@onready var options_button = get_node("ui/main_menu/options_button")

func _ready() -> void:
	pass
	#options_button.pressed.connect(_on_options_button_pressed)

func _on_options_button_pressed() -> void:
	var options_instance = OptionsMenuScene.instantiate()
	add_child(options_instance)
	options_instance.update_hotkey_data.connect(signal_settings.rebind)
	get_node("ui/main_menu").queue_free()

"""
var settings_node
var assignevent
func _ready() -> void:
	settings_node = get_node("data/settings")
	var key_name = settings_node.json_data["key"]  # e.g., "D"

	# Define the action you're rebinding
	var action_name = "key"  # This should match the action in your Input Map (Editor > Project Settings > Input Map)

	if key_name == "MOUSE_BUTTON":
		pass  # You said ignore this for now
	else:
		# Create a key input event
		assignevent = InputEventKey.new()
		assignevent.keycode = OS.find_keycode_from_string(key_name)
		assignevent.pressed = true

		# Clear old events for the action, and add new key event
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, assignevent)
	
func _process(_delta_time):
	if Input.is_action_pressed("key"):
		print("yep!")
"""
	
