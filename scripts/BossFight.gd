class_name BossFight
extends Level

onready var boss = $Crimeslime
onready var camera = $Camera2D
onready var start_timer = $StartTimer
onready var end_timer = $EndTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	boss.player = player
	boss.init_navigation()
	boss.connect("player_hit", self, "_on_player_hit")
	boss.connect("hurt", self, "_on_boss_hurt")
	start_timer.start()

func _on_player_hit():
	boss.behavior = Crimeslime.Behavior.PASSIVE
	player.die()
	camera.shake()
	end_timer.start()

func _on_boss_hurt():
	start_timer.disconnect("timeout", self, "_on_StartTimer_timeout")
	goal.visible = true
	grid.set_cell(8,1,-1)
	grid.fix_invalid_tiles()

func _on_StartTimer_timeout():
	boss.behavior = Crimeslime.Behavior.CHASE

func _on_EndTimer_timeout():
	Global.retry()
