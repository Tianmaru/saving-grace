class_name Crimeslime
extends Actor2D

export(int) var MOVE_SPEED = 80

signal player_hit
signal hurt

var navigation : AStar2D
var player : Player

enum Behavior {PASSIVE, CHASE}
export(Behavior) var behavior = Behavior.PASSIVE setget set_behavior

# Called when the node enters the scene tree for the first time.
func _ready():
	move_speed = MOVE_SPEED

func init_navigation():
	grid.fix_invalid_tiles()
	navigation = AStar2D.new()
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var pos = Vector2(i,j)
			if grid.get_cellv(pos) == TileMap.INVALID_CELL:
				navigation.add_point(get_point_id(pos), pos)
	var NEIGHBORS = [Vector2.DOWN, Vector2.RIGHT]
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var pos = Vector2(i,j)
			var id = get_point_id(pos)
			for neighbor in NEIGHBORS:
				var npos = pos + neighbor
				var nid = get_point_id(npos)
				if navigation.has_point(id) and navigation.has_point(nid):
					navigation.connect_points(id, nid)

func get_point_id(position : Vector2):
	return position.x * GRID_SIZE + position.y

func _on_HitBox_body_entered(body):
	emit_signal("player_hit")

func _process(delta):
	if behavior == Behavior.CHASE:
		chase(delta)

func update_navigation():
	# set points disabled if a block stands on it
	for point in navigation.get_points():
		navigation.set_point_disabled(point, false)
	for block in get_tree().get_nodes_in_group("block"):
		var block_pos = grid.world_to_map(block.position)
		var point_id = navigation.get_closest_point(block_pos)
		navigation.set_point_disabled(point_id, true)

func chase(delta):
	if is_moving:
		return
	update_navigation()
	var from_pos = grid.world_to_map(position)
	var to_pos = grid.world_to_map(player.position)
	var from_id = get_point_id(from_pos)
	var to_id = get_point_id(to_pos)
	var path = navigation.get_point_path(from_id, to_id)
	if len(path) > 1:
		move_to(path[1])

func set_behavior(value):
	behavior = value
	if value == Behavior.CHASE:
		print("HERE IS JOHNNY!")
		set_physics_process(true)
	elif value == Behavior.PASSIVE:
		set_physics_process(false)

func _on_HurtBox_body_entered(body):
	set_behavior(Behavior.PASSIVE)
	emit_signal("hurt")
