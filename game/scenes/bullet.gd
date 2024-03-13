extends Area2D
class_name Bullet

@export var speed = 750

var shooter: Player = null

func _enter_tree():
	set_multiplayer_authority(int(str(get_parent().name)))

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	if !is_multiplayer_authority():
		return
	
	queue_free()

func _on_body_entered(body):
	if !is_multiplayer_authority():
		return
	
	queue_free()
	
	if body.is_in_group("Zombies"):
		var zombie = body as Zombie
		zombie.take_damage.rpc_id(1, 1)
