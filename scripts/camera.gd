extends Camera2D

onready var anim = $AnimationPlayer

func glitch():
	anim.play("glitch")

func shake():
	anim.play("shake")
