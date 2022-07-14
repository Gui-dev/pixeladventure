extends Area2D


func _ready() -> void:
  pass


func _on_Trampoline_body_entered(body: Node) -> void:
  body.velocity.y = (body.jump_force * 1.6) / 2
  $animation.play('jump')
