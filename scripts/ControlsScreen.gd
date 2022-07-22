extends Control


func _ready() -> void:
  $return_button.grab_focus()


func _on_return_button_pressed() -> void:
  queue_free()
  Global.controll_off = false
