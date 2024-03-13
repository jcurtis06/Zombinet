extends Node2D

@onready var zombie_tscn: PackedScene = preload("res://game/scenes/zombie.tscn")
@onready var timer: Timer = $Timer

func start():
	timer.start()

func _on_timer_timeout():
	var zombie = zombie_tscn.instantiate() as Zombie
	add_child(zombie, true)
