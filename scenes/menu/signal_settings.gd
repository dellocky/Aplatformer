extends Node2D

@onready var settings_node = get_node("../../data/settings")

#recives the rebind command and stores the new information into the temparary json store
func rebind(data):
	print("Settings: Received rebind call with data:", data)
	var key = data[0] #field name
	var value = data[1] #field value
	settings_node.json_data["controls"][key] = value
	settings_node.json_store_write()
	print("Settings: Updated and saved settings")
