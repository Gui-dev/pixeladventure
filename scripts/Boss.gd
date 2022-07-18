extends EnemyBase


func _ready() -> void:
  set_physics_process(false)
   

func _physics_process(delta: float) -> void:
  apply_gravity(delta) 
  _set_animation()


func _on_Trigger_player_entered() -> void:
 set_physics_process(true)
