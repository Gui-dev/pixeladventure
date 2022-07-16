extends Area2D


func _ready() -> void:
  pass


func _on_fire_body_entered(body: Node) -> void:
  if body.has_method('player_damage'):
    body.player_damage()


func _on_start_timer_timeout() -> void:
  $animation.play('on')
  $collision_fire.set_deferred('disabled', false)


func _on_stop_timer_timeout() -> void:
  $animation.play('off')
  $collision_fire.set_deferred('disabled', true)
