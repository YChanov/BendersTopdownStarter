extends CharacterBody2D
class_name CharacterBase

@export var sprite : AnimatedSprite2D
@export var health_max : int = 100
var health : int
@export var healthbar : ProgressBar
@export var flipped_horizontal : bool
@export var hit_particles : GPUParticles2D
@export var damage: int = 55

var invincible : bool = false
var is_dead : bool = false

func _ready():
	health = health_max
	if healthbar :
		healthbar.max_value = health_max
		healthbar.value = health_max
	
func _process(_delta):
	Turn()
	if is_in_group('Player') :
		GameManager.set_health(health)

#Flip charater sprites based on their current velocity
func Turn():
	#This ternary lets us flip a sprite if its drawn the wrong way
	var direction = -1 if flipped_horizontal == true else 1
	
	if(velocity.x < 0):
		sprite.scale.x = -direction * abs(sprite.scale.x)
	elif(velocity.x > 0):
		sprite.scale.x = direction * abs(sprite.scale.x)

#region Taking Damage

#Play universal damage sound effect for any character taking damage and flashing red
func damage_effects():
	AudioManager.play_sound(AudioManager.BLOODY_HIT, 0, -3)
	after_damage_iframes()
	if(hit_particles):
		hit_particles.emitting = true

#After we are done flashing red, we can take damage again
func after_damage_iframes():
	invincible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.DARK_RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	await tween.finished
	invincible = false
	
func _take_damage(amount):
	if health >= health_max && amount < 0 :
		health = health_max
		return
	health -= amount
	if healthbar :
		healthbar.value = health
	
	if(health <= 0):
		_die()
		
func _die():
	if(is_dead):
		return
		
	is_dead = true
	#Remove/destroy this character once it's able to do so unless its the player
	if is_instance_valid(self) and not is_in_group("Player"):
		queue_free()

#endregion

#region save
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"position" : {"x" : position.x, "y" : position.y },
		"current_health" : health,
		"health_max" : health_max,
		"damage" : damage,
	}
	
	return save_dict
#endregion
