extends CharacterBody2D
class_name Zombie

var target: CharacterBody2D = null

var health = 3

func _enter_tree():
	set_multiplayer_authority(1)

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	if target == null:
		return
	
	var dir = global_position.direction_to(target.global_position)
	
	velocity = dir * 200
	move_and_slide()

func _on_detection_body_entered(body):
	if !is_multiplayer_authority():
		return
	
	if body.is_in_group("Players"):
		target = body

@rpc("any_peer", "call_local", "reliable")
func take_damage(amount: int):
	if !is_multiplayer_authority():
		return
	
	print("ouch")
	health -= amount
	
	if health <= 0:
		queue_free()
