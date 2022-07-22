extends Area2D


var game_over_scene = 'res://prefabs/GameOver.tscn'


func _on_fallzone_body_entered(body: Node) -> void:
  if body.name == 'Player':
    Global.player_life -= 1
    Global.player_health = 3
  
  if body.name == 'Player' and Global.player_life < 1:
    if get_tree().change_scene(game_over_scene) != OK:
      print('Algo deu errado')
  else:
    get_tree().reload_current_scene()
