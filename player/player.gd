extends CharacterBody2D

@export var player_camera: PackedScene
@export var camera_height = -350

@export var player_sprite: AnimatedSprite2D

@export var movement_speed = 300
@export var gravity = 30
@export var jump_strength = 600
@export var max_jumps = 1

@onready var initial_sprite_scale = player_sprite.scale

var jump_count = 0
var camera_instance: Camera2D


func _ready() -> void:
	set_up_camera()


func _process(_delta: float) -> void:
	update_camera_pos()


func _physics_process(_delta: float) -> void:
	var horizontal_input = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	velocity.x = horizontal_input * movement_speed
	velocity.y += gravity
	
	handle_movement_state()
	move_and_slide()
	face_movement_direction(horizontal_input)


func _on_animated_sprite_2d_animation_finished() -> void:
	player_sprite.play("jump")


func set_up_camera():
	camera_instance = player_camera.instantiate()
	camera_instance.global_position.y = camera_height
	get_tree().current_scene.add_child.call_deferred(camera_instance)


func update_camera_pos():
	camera_instance.global_position.x = global_position.x


func handle_movement_state():
	var is_idle = is_on_floor() and is_zero_approx(velocity.x)
	var is_walking = is_on_floor() and not is_zero_approx(velocity.x)
	var is_falling = not is_on_floor() and velocity.y > 0.0
	var is_jumping = is_on_floor() and Input.is_action_just_pressed("jump")
	var is_double_jumping = is_falling and Input.is_action_just_pressed("jump")
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
	
	# movement
	if is_jumping:
		jump_count += 1
		velocity.y = -jump_strength
	elif is_double_jumping:
		jump_count += 1
		if jump_count <= max_jumps:
			velocity.y = -jump_strength
	elif is_jump_cancelled:
		velocity.y = 0.0
	elif is_on_floor():
		jump_count = 0
	
	# animations
	if is_idle:
		player_sprite.play("idle")
	elif is_walking:
		player_sprite.play("walk")
	elif is_jumping:
		player_sprite.play("jump_start")
	elif is_double_jumping:
		player_sprite.play("double_jump_start")
	elif is_falling:
		player_sprite.play("fall")


func face_movement_direction(horizontal_input):
	if not is_zero_approx(horizontal_input):
		if horizontal_input < 0.0:
			# flip sprite horizontally by adjusting x scale
			player_sprite.scale = Vector2(-initial_sprite_scale.x, initial_sprite_scale.y)
		else:
			player_sprite.scale = initial_sprite_scale
