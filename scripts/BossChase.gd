class_name BossChase
extends Level

onready var anim = $Cutscene
onready var trigger = $Trigger
onready var boss = $Crimeslime
onready var camera = $Camera2D
onready var timer = $Timer

var is_loaded = false

func _ready():
	boss.player = player
	boss.init_navigation()
	if Global.chase_started:
		trigger.queue_free()
		start()

func start():
	Global.chase_started = true
	boss.behavior = Crimeslime.Behavior.CHASE
	boss.visible = true
	Global.play_music(1)
	yield(get_tree(), "physics_frame")
	boss.connect("player_hit", self, "_on_player_hit")

func _on_Trigger_body_entered(body):
	trigger.queue_free()
	anim.play("cutscene")

func _on_AnimationPlayer_animation_finished(anim_name):
	start()

func _on_player_hit():
	boss.behavior = Crimeslime.Behavior.PASSIVE
	player.die()
	camera.shake()
	timer.start()

func _on_Timer_timeout():
	Global.retry()
