class_name GridBody2D
extends KinematicBody2D

signal movement_finished

const GRID_SIZE = 10

var target_cell := Vector2()
var move_speed := 0
var is_moving := false setget set_moving
export(bool) var is_pushable := false

onready var grid : TileMap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_move(delta)

func _move(delta):
	if not is_moving:
		return
	var target_pos = grid.map_to_world(target_cell)
	var move_dir = target_pos - global_position
	if move_dir.length() < move_speed * delta:
		global_position = target_pos
		self.is_moving = false
		emit_signal("movement_finished")
	else:
		move_and_collide(move_dir.normalized() * move_speed * delta)

func can_move(direction : Vector2) -> bool:
	# test if collision would occur
	var transform = Transform2D()
	transform.origin = global_position 
	return not test_move(transform, direction * grid.cell_size.x)

func set_moving(value : bool):
	is_moving = value

func move_to(cell: Vector2):
	target_cell = cell
	self.is_moving = true

func move_in(direction: Vector2):
	move_to(grid.world_to_map(global_position) + direction.normalized())

func push(direction : Vector2, speed : float):
	if not is_pushable:
		return
	if not can_move(direction):
		print("Something is blocking the way!")
		return
	move_speed = speed
	move_in(direction)
