extends KinematicBody2D


export(Array, PackedScene) var fruit_instance
export(int, 0, 20, 1) var fruits
var division_x = 2
var division_y = 2
 

func create_fruit() -> void:
  var fruit_number = round(rand_range(0, fruit_instance.size() - 1))
  var fruit = fruit_instance[fruit_number].instance()
  fruit.global_position = $spawn_point.global_position
  fruit.apply_impulse(
    Vector2.ZERO,
    Vector2(rand_range(30, -30), -80)
  )
  get_parent().call_deferred('add_child', fruit)


func destroy() -> void:
  fruits -= 1
  
  if fruits < 0:
    var region = $texture.region_rect
    var texture = $texture.texture
    var size_x = region.size.x / division_x  
    var size_y = region.size.y / division_y
    
    for height in range(division_y):
      for width in range(division_x):
        var rect = Rect2(
          region.position.x + (size_x * width), 
          region.position.y + (size_y * height),
          size_x,
          size_y
        )
        var sprite = Sprite.new()  
        sprite.texture = texture
        sprite.region_enabled = true
        sprite.region_rect = rect
        sprite.centered = false
        sprite.global_position = $texture.global_position
        var rigid_body = RigidBody2D.new()
        rigid_body.add_child(sprite)
        get_parent().add_child(rigid_body)
        rigid_body.apply_impulse(
          Vector2.ZERO, 
          Vector2(rand_range(-50, 50), rand_range(-100, -150))
        )
        queue_free()
  else:
    create_fruit()
    $animation.play('hit')
