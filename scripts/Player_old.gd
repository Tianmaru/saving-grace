extends KinematicBody2D

signal goal_reached

const WALL_ID = 0
const MOVE_SPEED = 64

onready var world : TileMap = get_tree().get_nodes_in_group("world")[0]
onready var map_pos : Vector2 = world.world_to_map(position)

var is_moving := false
var goal_reached := false
var block = null
var block_parent = null
var target_pos := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	connect("goal_reached", Global, "next_level")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_moving:
		if not goal_reached:
			process_input()
	else:
		move(delta)

func process_input():
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
	if move_dir == Vector2.ZERO and animation != "idle":
		play("idle")
	map_pos = world.world_to_map(position)
	var new_map_pos = map_pos + move_dir
	if move_dir.length() != 0 and is_free(new_map_pos) and not is_block(map_pos):
		var blocked = false
		if is_block(new_map_pos):
			var new_block_pos = new_map_pos + move_dir
			if is_free(new_block_pos) and not is_block(new_block_pos):
				block = get_block(new_map_pos)
				block_parent = block.get_parent()
				block_parent.remove_child(block)
				var tmp_pos = block.global_position
				self.add_child(block)
				block.global_position = tmp_pos
			else:
				blocked = true
		if not blocked:
			is_moving = true
			play("move")
			target_pos = world.map_to_world(new_map_pos)
			map_pos = new_map_pos

func move(delta):
	var move_dir = target_pos - position
	if move_dir.length() < MOVE_SPEED * delta:
		position = target_pos
		is_moving = false
		if block:
			var tmp_pos = block.global_position
			remove_child(block)
			block_parent.add_child(block)
			block.global_position = world.map_to_world(world.world_to_map(tmp_pos))
		if is_goal(world.world_to_map(position)) and not goal_reached:
			emit_signal("goal_reached")
			goal_reached = true
	else:
		position += move_dir.normalized() * MOVE_SPEED * delta


func is_free(pos : Vector2):
	if world.get_cellv(pos) == WALL_ID:
		return false
	return true

func is_group(pos: Vector2, group : String):
	for member in get_tree().get_nodes_in_group(group):
		if world.world_to_map(member.position) == pos:
			return true
	return false

func is_block(pos: Vector2):
	return is_group(pos, "block")

func is_goal(pos: Vector2):
	return is_group(pos, "goal")

func get_block(pos: Vector2):
	for block in get_tree().get_nodes_in_group("block"):
		if world.world_to_map(block.position) == pos:
			return block
	return null
