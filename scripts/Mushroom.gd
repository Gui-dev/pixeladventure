extends KinematicBody2D


export var speed = 64
export var health = 1
var velocitty = Vector2.ZERO
var move_direction = -1

func _physics_process(delta: float) -> void:
  velocitty.x = speed * move_direction
  velocitty = move_and_slide(velocitty)
  
  if move_direction == 1:
    $texture.flip_h = true
  else:
     $texture.flip_h = false
    
  if $ray_wall.is_colliding():
    $animation.play('idle')


func _on_animation_animation_finished(anim_name: String) -> void:
  if anim_name == 'idle':
    $texture.flip_h != $texture.flip_h
    $ray_wall.scale.x *= -1
    move_direction *= -1
    $animation.play('run')
