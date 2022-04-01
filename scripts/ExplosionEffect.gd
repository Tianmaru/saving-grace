extends Node2D

onready var particles = $CPUParticles2D
onready var timer = $Timer

func _ready():
	particles.emitting = true
	timer.wait_time = particles.lifetime
	timer.start()

func _on_Timer_timeout():
	call_deferred("queue_free")
