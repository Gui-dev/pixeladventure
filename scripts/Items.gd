extends Area2D


export var fruits = 1

func _on_items_body_entered(body: Node) -> void:
  $collected_fx.play()
  $animation.play('collected')
  Global.fruits += fruits


func _on_animation_animation_finished(anim_name: String) -> void:
  if anim_name == 'collected':
    queue_free()
