extends Control

var warning = preload("res://scenes/Warning.tscn")

onready var anim = $TextRevealAnimation
onready var anim_blink = $VBoxContainer/BlinkAnimation

var game_started = false

func _ready():
	Global.set_process(false)

func _input(event):
	if event is InputEventKey and event.pressed and not game_started:
		if anim.is_playing():
			anim.advance(anim.current_animation_length - anim.current_animation_position)
		else:
			Global.start_game()
			game_started = true
