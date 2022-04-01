class_name Actor2D
extends Saveable2D

onready var anim : AnimatedSprite = $AnimatedSprite

var move_anim := "move"
var idle_anim := "idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_moving(moving : bool):
	.set_moving(moving)
	if moving and anim.animation != move_anim:
		play_animation(move_anim)
	elif anim.animation != idle_anim:
		play_animation(idle_anim)

func play_animation(animation : String):
	anim.play(animation)
