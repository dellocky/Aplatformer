extends Node2D
var key_button
var settings_node

func _ready():
	key_button = get_node("../../ui/rebind_buttons/key_button")
	settings_node = get_node("../../data/settings")

	# Connect key_button → signal_settings
	key_button.button_rebind.connect(rebind)

	# Store the settings node if needed
	
func rebind(data):
	settings_node.json_data[data[0]] = data[1]
	settings_node.json_store_write()
