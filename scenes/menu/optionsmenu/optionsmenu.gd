extends Control
#here!
signal update_hotkey_data(value: Array)

func _on_key_button_button_rebind(value: Array) -> void:
	print("OptionsMenu: Received button_rebind signal with value:", value)
	emit_signal("update_hotkey_data", value)
	print("OptionsMenu: Emitted update_hotkey_data signal")
