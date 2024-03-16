extends Node2D

@export var player_scene: PackedScene

@export var players_container: Node2D
@export var player_spawner: MultiplayerSpawner
@export var spawn_points: Array[Node2D]

const HOST_PLAYER_ID = 1

var next_spawn_point_index = 0


func _enter_tree() -> void:
	player_spawner.spawn_function = spawn_player


func _ready() -> void:
	# skip if not server
	if not multiplayer.is_server():
		return
		
	multiplayer.peer_disconnected.connect(delete_player)
		
	for id in multiplayer.get_peers():
		add_player(id)
		
	add_player(HOST_PLAYER_ID)


func _exit_tree() -> void:
	# skip if not connected
	if multiplayer.multiplayer_peer == null:
		return
	
	# skip if not server
	if not multiplayer.is_server():
		return

	multiplayer.peer_disconnected.disconnect(delete_player)


func add_player(id):
	player_spawner.spawn(id)
	
	
func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	players_container.get_node(str(id)).queue_free()
	
	
func spawn_player(id):
	var player_instance = player_scene.instantiate()
	player_instance.position = get_spawn_point()
	player_instance.name = str(id)
	players_container.add_child(player_instance)
	
	
func get_spawn_point():
	var spawn_point = spawn_points[next_spawn_point_index].position
	next_spawn_point_index += 1
	if next_spawn_point_index >= len(spawn_points):
		next_spawn_point_index = 0
	return spawn_point
