extends Area2D


var velocity = Vector2.ZERO
var speed_shoot = -100


func _physics_process(delta: float) -> void:
  velocity.x = speed_shoot * delta
  
  translate(velocity)


func _on_clear_shoot_screen_exited() -> void:
  queue_free()
