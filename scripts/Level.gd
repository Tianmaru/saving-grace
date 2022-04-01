class_name Level
extends Node2D

export(int) var song_id := -1

onready var grid : TileMap = $TileMap
onready var player = $Player
onready var goal = $Goal

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()

func setup():
	Global.set_process(true)
	Global.load_positions()
	Global.play_music(song_id)
	for body in get_tree().get_nodes_in_group("gridbody"):
		body.grid = grid
	if goal:
		goal.connect("body_entered", self, "_on_goal_reached")

func _on_goal_reached(body):
	player.set_input_enabled(false)
	yield(player, "movement_finished")
	Global.next_level()
