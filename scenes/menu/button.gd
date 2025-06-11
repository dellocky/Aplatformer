extends Button

func _ready() -> void:
	pressed.connect(go)
	
func go() -> void:
	print("hi")
