extends KinematicBody2D
class_name EnemyBase

export var speed = 32
export var health = 1
var motion = Vector2.ZERO
var move_direction = -1
var gravity = 1200
var hitted = false

func _physics_process(_delta: float) -> void:
  motion.x = speed * move_direction
  
  if move_direction == 1:
    $texture.flip_h = true
  else:
     $texture.flip_h = false
    
  motion = move_and_slide(motion)


func apply_gravity(delta: float) -> void:
  motion.y += gravity * delta


func _set_animation() -> void:
  var animation = 'run'
  
  if $ray_wall.is_colliding():
    animation = 'idle'
  elif motion.x != 0:
    animation = 'run'
    
  if hitted:
    animation = 'hit'
  
  if $animation.assigned_animation != animation:
    $animation.play(animation)


func _on_animation_animation_finished(anim_name: String) -> void:
  if anim_name == 'idle':
    $ray_wall.scale.x *= -1
    move_direction *= -1
    $animation.play('run')


func _on_Hitbox_body_entered(body: Node) -> void:
  hitted = true
  health -= 1    
  body.velocity.y = body.jump_force / 2 
  $hit_fx.play()
  yield(get_tree().create_timer(0.2), 'timeout')
  hitted = false
  
  if health < 1:
    get_node('Hitbox/collision').set_deferred('disabled', true)
    set_physics_process(false)
    get_node('collision').set_deferred('disabled', true)    
    yield(get_tree().create_timer(.7), 'timeout')
    queue_free()
