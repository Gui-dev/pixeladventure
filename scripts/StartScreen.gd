extends Control


func _ready() -> void:
  $controls/start_button.grab_focus()


func _on_start_button_pressed() -> void:
  get_tree().change_scene("res://levels/Level_01.tscn")


func _on_controls_button_pressed() -> void:
  var control_screen = load('res://scenes/ControlsScreen.tscn').instance()
  get_tree().current_scene.add_child(control_screen)
  


func _on_quit_button_pressed() -> void:
  get_tree().quit()
