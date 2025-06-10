extends JSONsilo

func _ready() -> void:
	file_path = ("res://resources/settings.json")
	json_load()
