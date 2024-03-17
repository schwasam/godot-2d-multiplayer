extends Node2D

@export var collider: CollisionShape2D
@export var sprite: Sprite2D
@export var required_activators = 2
@export var locked_open = false

var current_activators = 0


func activate(state):
	if locked_open:
		return
	
	if state:
		current_activators += 1
	else:
		current_activators -= 1
	
	if current_activators >= required_activators:
		locked_open = true
		set_bridge_props()


func set_bridge_props():
	collider.set_deferred("disabled", !locked_open)
	sprite.visible = locked_open


func _on_multiplayer_synchronizer_delta_synchronized() -> void:
	set_bridge_props()
