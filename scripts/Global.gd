extends Node

const FILE_PATH = "user://saving_grace-1.0.save"

var intro = preload("res://scenes/Intro.tscn")
var main = preload("res://scenes/Main.tscn")

var levels = [
	preload("res://scenes/level/Level1.tscn"),
	preload("res://scenes/level/Level2.tscn"),
	preload("res://scenes/level/Level3.tscn"),
	preload("res://scenes/level/Level4.tscn"),
	preload("res://scenes/level/Level5.tscn"),
	preload("res://scenes/level/Level6.tscn"),
	preload("res://scenes/level/Level7.tscn"),
	preload("res://scenes/level/Level8.tscn"),
	preload("res://scenes/level/Level9.tscn"),
	preload("res://scenes/level/Level10.tscn"),
	preload("res://scenes/level/BossChase.tscn"),
	preload("res://scenes/level/BossFight.tscn"),
	preload("res://scenes/level/End.tscn")
]

var current_level := 0
var player = null
var saveables = []
var seen_cutscenes = []
var chase_started = false
var position_data := []

onready var anim = $AnimationPlayer
onready var cyber_anim = $CyberAnim
onready var cyber = $CanvasLayer/CyberEffect
onready var save_msg = $UILayer/SaveMsg
onready var saveable_label = $UILayer/SaveMsg/HBoxContainer/VBoxContainer/HBoxContainer/SaveableName
onready var music = $Music

class NodeSorter:
	static func sort_by_name(a, b):
		return a.name < b.name

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		save_msg.visible = false
		stop_music()
		get_tree().paused = false
		get_tree().change_scene_to(main)
		cyber_anim.stop()
		cyber.material.set_shader_param("progress",0)
	if get_tree().paused:
		return

func save_game_exists():
	#return false
	return File.new().file_exists(FILE_PATH)

func delete_save_game():
	current_level = 0
	seen_cutscenes = []
	chase_started = false
	Directory.new().remove(FILE_PATH)

func retry():
	chase_started = false
	load_current_level()

func save_game():
	get_tree().paused = true
	save_msg.visible = true
	cyber_anim.play("cyber_in")
	var save_file = File.new()
	save_file.open(FILE_PATH, File.WRITE)
	var data = {
		"level": current_level,
		"seen_cutscenes": seen_cutscenes,
		"chase_started": chase_started,
		"song_id": get_song_id(),
		"song_pos": get_song_pos(),
	}
	save_file.store_line(to_json(data))
	save_file.close()
	saveables = []
	player = get_tree().get_nodes_in_group("player")
	var npcs = get_tree().get_nodes_in_group("npc")
	var blocks = get_tree().get_nodes_in_group("block")
	blocks.sort_custom(NodeSorter, "sort_by_name")
	for item in player + npcs + blocks:
		item.start_saving()
		item.connect("saved", self, "_on_saved")
		saveables.append(item)
	save_next()

func save_next():
	var s = saveables.pop_front()
	s.save()
	saveable_label.text = s.name

func _on_saved(saveable : Saveable2D):
	var data = saveable.get_data()
	var save_file = File.new()
	save_file.open(FILE_PATH, File.READ_WRITE)
	save_file.seek_end()
	save_file.store_line(to_json(data))
	save_file.close()
	if len(saveables) > 0:
		save_next()
	else:
		get_tree().paused = false
		save_msg.visible = false
		cyber_anim.play("cyber_out")

func load_game():
	var save_file = File.new()
	if not save_file.file_exists(FILE_PATH):
		return
	save_file.open(FILE_PATH, File.READ)
	var data = parse_json(save_file.get_line())
	current_level = int(data["level"])
	if "seen_cutscenes" in data:
		seen_cutscenes = data["seen_cutscenes"]
	chase_started = data["chase_started"]
	play_music(data["song_id"], data["song_pos"])
	position_data = []
	while save_file.get_position() < save_file.get_len():
		position_data.append(parse_json(save_file.get_line()))
	save_file.close()
	load_current_level()
	get_tree().paused = false

func load_positions():
	for data in position_data:
		var node = get_node(data["path"])
		node.load_data(data)
	position_data = []

func start_game():
	load_current_level()

func next_level():
	current_level += 1
	load_current_level()

func load_current_level():
	load_level(levels[current_level % levels.size()])

func load_level(level):
	anim.play("fade_out")
	yield(anim,"animation_finished")
	get_tree().change_scene_to(level)
	anim.play("fade_in")

func get_song_id():
	for i in range(music.get_child_count()):
		if music.get_child(i).playing:
			return i
	return -1

func get_song_pos():
	var song_id = get_song_id()
	if song_id == -1:
		return 0
	return music.get_child(song_id).get_playback_position()

func stop_music():
	for song in music.get_children():
		song.stop()

func play_music(song_id : int, from := 0):
	if song_id == -1:
		stop_music()
	else:
		var song = music.get_children()[song_id]
		if not song.playing:
			stop_music()
			song.play(from)
