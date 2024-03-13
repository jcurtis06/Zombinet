extends CharacterBody2D
class_name Zombie

enum ZombieState {
	WANDER,
	CHASE
}

var targeted_player: CharacterBody2D
var target: Vector2

var health = 3
var state = ZombieState.WANDER

func _enter_tree():
	set_multiplayer_authority(1)

func _ready():
	if !is_multiplayer_authority():
		return
	
	target = _rand_within(900)

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	if targeted_player != null:
		target = targeted_player.global_position
	
	if global_position.distance_to(target) < 50 && state == ZombieState.WANDER:
		target = _rand_within(900)
	
	var dir = global_position.direction_to(target)
	
	velocity = dir * 200
	move_and_slide()

func _on_detection_body_entered(body):
	if !is_multiplayer_authority():
		return
	
	if body.is_in_group("Players"):
		state = ZombieState.CHASE
		targeted_player = body

func _on_detection_body_exited(body):
	if !is_multiplayer_authority():
		return
	
	if body.is_in_group("Players"):
		state = ZombieState.WANDER
		targeted_player = null
		target = _rand_within(900)

func _rand_within(radius: int) -> Vector2:
	var angle = randf() * 2 * PI
	var distance = sqrt(randf()) * radius
	var x = cos(angle) * distance
	var y = sin(angle) * distance
	return Vector2(x, y)

@rpc("any_peer", "call_local", "reliable")
func take_damage(amount: int):
	if !is_multiplayer_authority():
		return
	
	health -= amount
	
	if health <= 0:
		queue_free()
