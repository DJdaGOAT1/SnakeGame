extends CanvasLayer
signal restart

func _on_button_pressed(): 
	restart.emit()
	
func _on_button_2_pressed():
	get_tree().quit() # Replace with function body.
