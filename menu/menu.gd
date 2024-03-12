extends Node

@export var level_container: Node
@export var level_scene: PackedScene

@export var ui: Control
@export var not_connected_hbox: HBoxContainer
@export var host_hbox: HBoxContainer
@export var ip_line_edit: LineEdit
@export var status_label: Label


func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)


func _on_host_button_pressed() -> void:
	not_connected_hbox.hide()
	host_hbox.show()
	Lobby.create_game()
	status_label.text = "Hosting!"

func _on_join_button_pressed() -> void:
	not_connected_hbox.hide()
	Lobby.join_game(ip_line_edit.text)
	status_label.text = "Connecting..."
	

func _on_start_button_pressed() -> void:
	hide_menu.rpc()
	change_level.call_deferred(level_scene)
	
	
func change_level(scene):
	for child in level_container.get_children():
		level_container.remove_child(child)
		child.queue_free()
	level_container.add_child(scene.instantiate())
	
	
func _on_connected_to_server():
	status_label.text = "Connected!"
	
	
func _on_connection_failed():
	not_connected_hbox.show()
	status_label.text = "Failed to connect..."
	
	
@rpc("call_local", "authority", "reliable")
func hide_menu():
	ui.hide()
