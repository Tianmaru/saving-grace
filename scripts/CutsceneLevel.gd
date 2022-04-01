extends Level

onready var cutscene = $Cutscene

# Called when the node enters the scene tree for the first time.
func _ready():
	cutscene.connect("skipped", self, "_on_skip")

func _on_skip():
	cutscene.queue_free()
	player.input_enabled = true
