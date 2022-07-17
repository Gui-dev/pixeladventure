extends Area2D


signal player_entered


func _physics_process(_delta: float) -> void:
  var bodies = get_overlapping_bodies()
  
  for body in bodies:
    if body.name == 'Player':
      emit_signal('player_entered')
      queue_free()
