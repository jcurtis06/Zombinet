extends Node2D

@onready var player_tscn: PackedScene = preload("res://game/scenes/player_sandbox.tscn")
@onready var zombie_tscn: PackedScene = preload("res://game/scenes/zombie.tscn")

@onready var _zombie_spawn: Node2D = $ZombieSpawn
@onready var clock: Timer = $Clock

var time = 1200

func _on_start_pressed():
	if LobbyManager.is_host:
		if LobbyManager.debug:
			_start_game()
		else:
			_start_game.rpc_id(1)

@rpc("any_peer")
func _start_game():
	if !multiplayer.is_server():
		return
	
	for peer in multiplayer.get_peers():
		var player = player_tscn.instantiate()
		player.name = str(peer)
		add_child(player, true)
		
		var zombie = zombie_tscn.instantiate()
		_zombie_spawn.add_child(zombie, true)
	
	for spawner in get_tree().get_nodes_in_group("Spawners"):
		spawner.start()
	
	clock.start()

func _on_clock_timeout():
	if !multiplayer.is_server():
		return
	
	time_tick.rpc()

@rpc("authority", "reliable", "call_local")
func time_tick():
	time += 1
	$UI/Label.text = str(time)
