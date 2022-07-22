extends Label


func _process(_delta: float) -> void:
  text = String('%04d' % Global.fruits)
