extends EnemyBase


signal boss_dead


func _ready() -> void:
  set_physics_process(false)


func _physics_process(delta: float) -> void:
  apply_gravity(delta) 
  _set_animation()
  

func _set_animation() -> void:
  var animation = 'run'
  
  if $ray_wall.is_colliding():
    animation = 'idle'
  elif motion.x != 0 and health > 3:
    animation = 'run'
  elif motion.x != 0 and health < 3:
    animation = 'angry_run'
    speed = 64
    
  if hitted:
    animation = 'hit'
    
  if health < 1:
    animation = 'die'
    emit_signal('boss_dead')
  
  if $animation.assigned_animation != animation:
    $animation.play(animation)
    

func _on_Trigger_player_entered() -> void:
  set_physics_process(true)
