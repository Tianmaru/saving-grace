class_name Cutscene
extends AnimationPlayer

signal skipped

export(String) var animation = "cutscene"
export(String) var skip_anim = "skip"
export(bool) var auto_start = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_path() in Global.seen_cutscenes:
		play("skip")
	elif auto_start:
		start()

func start():
	if not get_path() in Global.seen_cutscenes:
		play(animation)
		connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(anim_name):
	Global.seen_cutscenes.append(get_path())
