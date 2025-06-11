extends Node2D

@onready var settings_node = get_node("../../data/settings")

func rebind(data):
	print("Settings: Received rebind call with data:", data)
	settings_node.json_data[data[0]] = data[1]
	settings_node.json_store_write()
	print("Settings: Updated and saved settings")
