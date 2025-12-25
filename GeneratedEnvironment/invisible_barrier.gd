@tool
extends RigidBody2D
class_name InvisibleBarrier
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var A: Vector2  = Vector2.ZERO :
	set(v):
		A=v
		notify_property_list_changed()
@export var B: Vector2 = Vector2.ZERO :
	set(v):
		B=v
		notify_property_list_changed()
		
		
func _ready() -> void:
	var shape : SegmentShape2D = collision_shape_2d.shape
	shape.a = A
	shape.b = B
