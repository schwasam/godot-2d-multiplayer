extends Node2D

@export var is_down = false
@export var plate_up: Sprite2D
@export var plate_down: Sprite2D

var bodies_on_plate = 0


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	bodies_on_plate += 1
	update_plate_state()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if not multiplayer.is_server():
		return
	bodies_on_plate -= 1
	update_plate_state()


func update_plate_state():
	is_down = bodies_on_plate > 0
	set_plate_props()
	
	
func set_plate_props():
	plate_up.visible = !is_down
	plate_down.visible = is_down


func _on_multiplayer_synchronizer_delta_synchronized() -> void:
	set_plate_props()
