extends Area2D


func _ready() -> void:
  pass


func _on_CheckPoint_body_entered(body: Node) -> void:
  if body.name == 'Player':
    body.hit_checkpoint()
    $animation.play('checked')
    $collision.queue_free()
