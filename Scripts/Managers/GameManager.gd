extends Node

var slime = 0
var wood = 0
var metal = 0

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

func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)

func load_same_level():
	get_tree().reload_current_scene()
