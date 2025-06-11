extends RebindButton


func _ready() -> void:
	action = "key"
	pressed.connect(_on_button_pressed)
