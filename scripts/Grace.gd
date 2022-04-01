class_name Grace
extends Actor2D

signal loved

func _on_LoveBox_body_entered(body):
	emit_signal("loved")
