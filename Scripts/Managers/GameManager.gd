extends Node

var movement_speed : float = 1.0
var t_group : String
var health

func set_health(sethealth):
	health = sethealth

func reset_money():
	movement_speed = 1.0
	
func set_all_money_to_zero():
	movement_speed = 1.0

func set_movement_speed(setmovement_speed : float) :
	movement_speed = setmovement_speed
	
func reset_movement_speed():
	movement_speed = 1

func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func load_same_level():
	get_tree().reload_current_scene()
