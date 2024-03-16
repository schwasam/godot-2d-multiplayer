extends Node2D

@export var is_open = false
@export var door_open: Sprite2D
@export var door_closed:Sprite2D
@export var collider: CollisionShape2D


func activate(state):
	if not multiplayer.is_server():
		return
	is_open = state
	set_door_props()


func set_door_props():
	door_open.visible = is_open
	door_closed.visible = !is_open
	collider.set_deferred("disabled", is_open)


func _on_multiplayer_synchronizer_delta_synchronized() -> void:
	set_door_props()
