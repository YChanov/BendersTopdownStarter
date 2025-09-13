extends Keyword
class_name fire

const WOOD_RESOURCE = preload("res://Art/wood_resource.png")

func ready(magic: Node):
	var sprite = Sprite2D.new()
	sprite.texture = WOOD_RESOURCE
	magic.add_child(sprite)
	
