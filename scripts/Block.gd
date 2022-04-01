class_name Block
extends Saveable2D

var effect = preload("res://scenes/ExplosionEffect.tscn")

func _ready():
	._ready()
	is_pushable = true

func _on_Area2D_area_entered(area):
	var explosion_vfx = effect.instance()
	explosion_vfx.global_position = global_position
	get_parent().add_child(explosion_vfx)
	call_deferred("queue_free")
