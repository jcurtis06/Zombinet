extends CharacterBody2D
class_name Player

@export var speed = 400

@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var bullet_tscn: PackedScene = preload("res://game/scenes/bullet.tscn")

#func _enter_tree():
	#set_multiplayer_authority(int(str(name)))

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())

#@rpc("any_peer", "call_remote", "reliable")
func shoot():
	var bullet := bullet_tscn.instantiate() as Bullet
	bullet.shooter = self
	get_parent().add_child(bullet, true)
	bullet.transform = $Muzzle.global_transform
