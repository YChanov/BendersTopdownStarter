extends Node

var slime = 0
var wood = 0
var metal = 0
var road = 10
var movement_speed : float = 1.0
var t_group : String
var health

func set_health(sethealth):
	health = sethealth

func reset_money():
	slime = 5
	wood = 5
	metal = 5
	movement_speed = 1.0
	
func set_all_money_to_zero():
	slime = 0
	wood = 0
	metal = 0
	movement_speed = 1.0
	road = 0

func set_movement_speed(setmovement_speed : float) :
	movement_speed = setmovement_speed
	
func reset_movement_speed():
	movement_speed = 1
	
func reset_metal():
	metal = 0
	
func reset_slime():
	slime = 0
	
func reset_wood():
	wood = 0

func add_metal(addsmetal : int):
	metal += addsmetal

func add_slime(addslime : int):
	slime += addslime

func add_wood(addswood : int):
	wood += addswood
	
func add_road(addroad : int):
	road += addroad

func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func load_same_level():
	get_tree().reload_current_scene()
