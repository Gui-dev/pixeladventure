extends Area2D


var game_over_scene = 'res://prefabs/GameOver.tscn'


func _on_fallzone_body_entered(body: Node) -> void:
  if body.name == 'Player':
    get_tree().change_scene(game_over_scene)
