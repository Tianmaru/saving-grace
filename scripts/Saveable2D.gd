class_name Saveable2D
extends GridBody2D

signal saved(saveable)

const SAVE_TIME = 2.0

var save_effect_scn = preload("res://scenes/SaveEffect.tscn")

var save_effect
var tween : Tween

onready var sprite = $AnimatedSprite

func get_data():
	var data = {}
	data["path"] = get_path()
	data["pos_x"] = position.x
	data["pos_y"] = position.y
	return data

func load_data(data):
	position = Vector2(data["pos_x"], data["pos_y"])

func set_progress(value):
	if not sprite:
		return
	sprite.material.set_shader_param("progress", value)

func save():
	print("saving")
	tween = Tween.new()
	tween.pause_mode = PAUSE_MODE_PROCESS
	add_child(tween)
	tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	tween.interpolate_method(self, "set_progress", 0.0, 1.0, SAVE_TIME)
	tween.start()

func start_saving():
	save_effect = save_effect_scn.instance()
	add_child(save_effect)
	set_progress(0)

func stop_saving():
	set_progress(1)
	if save_effect:
		save_effect.queue_free()
	if tween:
		tween.queue_free()

func _on_Tween_tween_completed(object, key):
	emit_signal("saved", self)
	stop_saving()
