class_name Player
extends Actor2D

const MOVE_SPEED = 64
const PUSH_SPEED = 32

export(bool) var input_enabled = true setget set_input_enabled

onready var sound = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	move_speed = MOVE_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_moving and input_enabled:
		process_input(delta)

func process_input(delta):
	if Input.is_action_just_pressed("save"):
		Global.save_game()
	elif Input.is_action_just_pressed("retry"):
		input_enabled = false
		Global.retry()
	else:
		var move_dir = Vector2()
		if Input.is_action_pressed("move_right"):
			move_dir.x += 1
		if Input.is_action_pressed("move_left"):
			move_dir.x -= 1
		if Input.is_action_pressed("move_down"):
			move_dir.y += 1
		if Input.is_action_pressed("move_up"):
			move_dir.y -= 1
		if move_dir.x != 0 and move_dir.y != 0:
			move_dir = Vector2.ZERO
		move_or_push(move_dir)

func move_or_push(move_dir):
	var collision = move_and_collide(move_dir * (grid.cell_size.x), true, true, true)
	move_speed = MOVE_SPEED
	move_anim = "move"
	if collision:
		var collider = collision.get_collider()
		if collider is GridBody2D and collider.is_pushable and not collider.is_moving and collider.can_move(move_dir):
			move_speed = PUSH_SPEED
			move_anim = "push"
			collider.push(move_dir, PUSH_SPEED)
		else:
			move_dir = Vector2.ZERO
	if move_dir.length() > 0:
		move_in(move_dir)

func set_enabled(enabled: bool):
	set_process(enabled)
	set_physics_process(enabled)

func set_input_enabled(enabled: bool):
	input_enabled = enabled

func _on_got_stuck(body):
	anim.play("dead")

func die():
	set_enabled(false)
	set_input_enabled(false)
	anim.play("dead")
	sound.play()
