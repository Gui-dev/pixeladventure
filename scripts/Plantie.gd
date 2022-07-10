extends KinematicBody2D


var facing_left = true
var hitted = false
var health = 3
onready var bullet_instance = preload('res://scenes/Seed.tscn')
onready var player = Global.get('player')


func _physics_process(_delta: float) -> void:
  _set_animation()
  
  if player:
    var distance = player.global_position.x - self.position.x
    facing_left = true if distance < 0 else false
    
  if facing_left:
    self.scale.x = 1
  else:
    self.scale.x = -1
    

func shoot() -> void:
  var bullet = bullet_instance.instance()
  get_parent().add_child(bullet)
  bullet.global_position = $spawn_shoot.global_position
  
  if facing_left:
    bullet.direction = 1
  else:
    bullet.direction = -1


func _set_animation() -> void:
  var animation = 'idle'
  
  if $player_detector.overlaps_body(player):
    animation = 'attack'
  else:
    animation = 'idle'
    
  if hitted:
    animation = 'hit'
  
  if $animation.assigned_animation != animation:
    $animation.play(animation)
    

func _on_player_detector_body_entered(_body: Node) -> void:
  $animation.play('attack')


func _on_player_detector_body_exited(_body: Node) -> void:
  $animation.play('idle')


func _on_hitbox_body_entered(body: Node) -> void:
  hitted = true
  health -= 1    
  body.velocity.y = body.jump_force / 2 
  yield(get_tree().create_timer(0.2), 'timeout')
  hitted = false
  
  if health < 1:
    queue_free()
    get_node('hitbox/collision').set_deferred('disabled', true)
