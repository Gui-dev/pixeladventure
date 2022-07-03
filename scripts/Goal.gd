extends Area2D


onready var changer = get_parent().get_node('Transition_in')
export(String) var path

func _ready() -> void:
  pass


func _on_Goal_body_entered(body: Node) -> void:
  if body.name == 'Player':
    $confetti.emitting = true
    changer.change_scene(path)
    Global.checkpoint_position = 0
