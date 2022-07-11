extends KinematicBody2D


var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 1200
var jump_force = -720
var is_grounded
var player_health = 3
var max_health = 3
var hurted = false
var knockback_direction = 1
var knockback_intensity = 1500
var up = Vector2.UP
onready var raycasts = $raycasts 

signal change_life(player_health)


func _ready() -> void:
  Global.set('player', self)
  connect('change_life', get_parent().get_node('HUD/HBoxContainer/heart'), 'on_change_life')
  emit_signal('change_life', max_health)
  position.x = Global.checkpoint_position + 50
 
 
func _physics_process(delta: float) -> void:
  velocity.y += gravity * delta
  velocity.x = 0
  
  if !hurted:
    _get_input()
      
  velocity = move_and_slide(velocity, up)
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
    $steps_fx.scale.x = move_direction

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('ui_jump') and is_grounded:
    velocity.y = jump_force / 2
    $jump_fx.play()

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
    $steps_fx.emitting = true
    
  if velocity.y > 0 and !is_grounded:
    animation = 'fall'
    
  if hurted:
    animation = 'hit'
  
  if $animation.assigned_animation != animation:
    $animation.play(animation)


func knockback() -> void:
  if $right.is_colliding():
    velocity.x = -(knockback_direction * knockback_intensity)
    
  if $left.is_colliding():
    velocity.x = knockback_direction * knockback_intensity
    
  velocity = move_and_slide(velocity)


func hit_checkpoint():
  Global.checkpoint_position = position.x

func _on_hurtbox_body_entered(_body: Node) -> void:
  hurted = true
  player_health -= 1
  emit_signal('change_life', player_health)
  knockback()
  get_node('hurtbox/collision').set_deferred('disabled', true)
  yield(get_tree().create_timer(.5), 'timeout')
  get_node('hurtbox/collision').set_deferred('disabled', false)
  hurted = false
  
  if player_health < 1:
    queue_free()
    get_tree().reload_current_scene()


func _on_head_collider_body_entered(body: Node) -> void:
  if body.has_method('destroy'):
    body.destroy()


func _on_hurtbox_area_entered(_area: Area2D) -> void:
  hurted = true
  player_health -= 1
  emit_signal('change_life', player_health)
  knockback()
  get_node('hurtbox/collision').set_deferred('disabled', true)
  yield(get_tree().create_timer(.5), 'timeout')
  get_node('hurtbox/collision').set_deferred('disabled', false)
  hurted = false
  
  if player_health < 1:
    queue_free()
    get_tree().reload_current_scene()
