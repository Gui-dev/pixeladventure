extends Area2D


func _on_items_body_entered(body: Node) -> void:
  $animation.play('collected')


func _on_animation_animation_finished(anim_name: String) -> void:
  if anim_name == 'collected':
    queue_free()
