extends Control

var intro = preload("res://scenes/Intro.tscn")

onready var continue_btn = $Buttons/ContinueButton
onready var start_btn = $Buttons/StartButton
onready var quit_btn = $Buttons/QuitButton
onready var warning = $Buttons/Warning
onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	start_btn.grab_focus()
	if Global.save_game_exists():
		continue_btn.disabled = false
		continue_btn.grab_focus()
	if not OS.is_userfs_persistent():
		# display warning
		start_btn.disabled = true
		warning.visible = true
		#get_tree().change_scene_to(warning)

func start_transition():
	anim.play("fade_out")
	start_btn.disconnect("button_down", self, "_on_StartButton_button_down")
	continue_btn.disconnect("button_down", self, "_on_ContinueButton_button_down")
	quit_btn.disconnect("button_down", self, "_on_QuitButton_button_down")

func _on_StartButton_button_down():
	start_transition()
	yield(anim, "animation_finished")
	Global.delete_save_game()
	get_tree().change_scene_to(intro)

func _on_ContinueButton_button_down():
	start_transition()
	yield(anim, "animation_finished")
	Global.load_game()

func _on_QuitButton_button_down():
	get_tree().quit()
