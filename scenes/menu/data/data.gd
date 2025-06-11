class_name JSONsilo

extends Node
var file_path : String
var json_data := {}  # In-memory JSON structure


func json_display_file() -> void:
	if not FileAccess.file_exists(file_path):
		print("File not found:", file_path)
		

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parsed = JSON.parse_string(content)
		if parsed is Dictionary and parsed.has("text"):
			print(parsed["text"])
		else:
			print("Invalid JSON or missing 'text' key.")

func json_read_store() -> void:
	print(json_data)

# Loads the JSON file into the in-memory dictionary (json_data)
func json_load() -> void:
	if not FileAccess.file_exists(file_path):
		push_warning("File not found: " + file_path)
		json_data = {}


	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var parsed = JSON.parse_string(content)
		if parsed is Dictionary:
			json_data = parsed
		else:
			push_warning("Failed to parse JSON or file does not contain a dictionary.")
			json_data = {}
			
# Writes the entire contents of `json_data` to the file
func json_store_write():
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(json_data))
		file.close()
	else:
		push_warning("Failed to open file for writing.")

func get_store() -> Dictionary:
	return json_data
