extends KinematicBody2D


var facing_left = true
onready var bullet_instance = preload('res://scenes/Seed.tscn')
onready var player = Global.get('player')


func _physics_process(delta: float) -> void:
  if player:
    var distance = player.global_position.x - self.position.x
    facing_left = true if distance < 0 else false
    
  if facing_left:
    self.scale.x = 1
  else:
    self.scale.x = -1
    

func shoot() -> void:
  var bullet = bullet_instance.instance()
  add_child(bullet)
  bullet.global_position = $spawn_shoot.global_position


func _on_player_detector_body_entered(body: Node) -> void:
  $animation.play('attack')


func _on_player_detector_body_exited(body: Node) -> void:
  $animation.play('idle')


func _on_hitbox_body_entered(body: Node) -> void:
  queue_free()
