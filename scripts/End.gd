extends Level

var true_end = preload("res://scenes/level/TrueEnd.tscn")

func _on_Grace_loved():
	Global.stop_music()
	get_tree().change_scene_to(true_end)
