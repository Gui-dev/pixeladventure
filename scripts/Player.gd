extends KinematicBody2D


var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 1200
var jump_force = -720
var is_grounded
var health = 3
var hurted = false
var knockback_direction = 1
var knockback_intensity = 500
onready var raycasts = $raycasts 

func _ready() -> void:
  pass
  
func _physics_process(delta: float) -> void:
  velocity.y += gravity * delta
  
  _get_input()    
  velocity = move_and_slide(velocity)
  is_grounded = _check_is_grounded()
  _set_animation()
  
  for platforms in get_slide_count():
    var collision = get_slide_collision(platforms)
    
    if collision.collider.has_method('collide_with'):
      collision.collider.collide_with(collision, self)
  

func _get_input() -> void:
  velocity.x = 0
  var move_direction = int(Input.is_action_pressed('ui_move_right')) - int(Input.is_action_pressed('ui_move_left'))
  velocity.x = lerp(velocity.x,  move_speed * move_direction, 0.2)
  
  if move_direction != 0:
    $texture.scale.x = move_direction
    knockback_direction = move_direction

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('ui_jump') and is_grounded:
    velocity.y = jump_force / 2

func _check_is_grounded() -> bool:
  for raycast in raycasts.get_children():
    if raycast.is_colliding():
      return true
  return false


func _set_animation() -> void:
  var animation = 'idle'
  
  if !is_grounded:
    animation = 'jump'
  elif velocity.x != 0:
    animation = 'run'
    
  if velocity.y > 0 and !is_grounded:
    animation = 'fall'
    
  if hurted:
    animation = 'hit'
  
  if $animation.assigned_animation != animation:
    $animation.play(animation)


func knockback() -> void:
  velocity.x = -knockback_direction * knockback_intensity
  velocity = move_and_slide(velocity)

func _on_hurtbox_body_entered(_body: Node) -> void:
  hurted = true
  health -= 1
  knockback()
  get_node('hurtbox/collision').set_deferred('disabled', true)
  yield(get_tree().create_timer(.5), 'timeout')
  get_node('hurtbox/collision').set_deferred('disabled', false)
  hurted = false
  
  if health < 1:
    queue_free()
    get_tree().reload_current_scene()
