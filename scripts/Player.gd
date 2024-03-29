extends KinematicBody2D


var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 1200
var jump_force = -720
var is_grounded
var max_health = 3
var player_life = 3
var hurted = false
var knockback_direction = 1
var knockback_intensity = 1500
var up = Vector2.UP
onready var raycasts = $raycasts 
var is_pushing  = false

var game_over_scene = 'res://prefabs/GameOver.tscn'

signal change_life(player_health)


func _ready() -> void:
  Global.set('player', self)
  connect('change_life', get_parent().get_node('HUD/HBoxContainer/heart'), 'on_change_life')
  emit_signal('change_life', max_health)
#  position.x = Global.checkpoint_position
 
 
func _physics_process(delta: float) -> void:
  velocity.y += gravity * delta
  velocity.x = 0
  
  if !hurted:
    _get_input()
      
  if $push_right.is_colliding():
    var object = $push_right.get_collider()
    object.move_and_slide(Vector2(30, 0) * move_speed * delta)
    is_pushing = true
  elif $push_left.is_colliding():
    var object = $push_left.get_collider()
    object.move_and_slide(Vector2(-30, 0) * move_speed * delta)
    is_pushing = true
  else:
    is_pushing = false 
  
  velocity = move_and_slide(velocity, up)
  is_grounded = _check_is_grounded()
  
  if is_grounded:
    $shadow.visible = true
  else:
    $shadow.visible = false
  
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
    
  if velocity.x > 1:
    $push_right.set_enabled(true)
  else:
    $push_right.set_enabled(false)
    
  if velocity.x < -1:
    $push_left.set_enabled(true)
  else:
    $push_left.set_enabled(false)
    

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
  elif velocity.x != 0 or is_pushing:
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


func game_over() -> void:
  if Global.player_health < 1:
    queue_free()
    Global.is_dead = true
    Global.player_life -= 1
    Global.player_health = 3
    get_tree().reload_current_scene()
  if Global.player_life < 1:
    if get_tree().change_scene(game_over_scene) != OK:
      print('Algo deu errado')


func player_damage() -> void:
  hurted = true
  Global.player_health -= 1
  emit_signal('change_life', Global.player_health)
  knockback()
  get_node('hurtbox/collision').set_deferred('disabled', true)
  yield(get_tree().create_timer(.5), 'timeout')
  get_node('hurtbox/collision').set_deferred('disabled', false)
  hurted = false
  
  game_over()


func _on_hurtbox_body_entered(_body: Node) -> void:
  player_damage()


func _on_head_collider_body_entered(body: Node) -> void:
  if body.has_method('destroy'):
    body.destroy()


func _on_hurtbox_area_entered(_area: Area2D) -> void:
  player_damage()
  

func _on_Trigger_player_entered() -> void:
  $camera.current = false


func _on_Boss_boss_dead() -> void:
  $camera.current = true
