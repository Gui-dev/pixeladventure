extends Node


var checkpoint_position = 0

func _ready() -> void:
  Global.fruits = 0


func _on_Trigger_player_entered_camera() -> void:
  $boss_camera.current = true


func _on_Boss_boss_dead() -> void:
  $boss_camera.current = false
