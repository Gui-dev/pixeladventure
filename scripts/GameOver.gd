extends CanvasLayer


func _ready() -> void:
  pass


func _on_button_retry_pressed() -> void:
  get_tree().change_scene('res://levels/Level_02.tscn')
