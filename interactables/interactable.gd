extends Area2D

signal interacted()


@rpc("any_peer", "call_local", "reliable")
func interact():
	if not multiplayer.is_server():
		return
		
	interacted.emit()
