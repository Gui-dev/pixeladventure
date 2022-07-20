extends StaticBody2D


signal closed_door


func _ready() -> void:
  pass


func _on_Trigger_player_entered() -> void:
  $animation.play('active')


func _on_Boss_boss_dead() -> void:
  $animation.play('inactive')
