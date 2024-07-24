## Responsible for accessing and storing various data in the game.
extends Node

var character_jobs: Array[Job] = []

func _ready() -> void:
	load_jobs()

func load_jobs() -> void:
	var data_path: String = "res://Game Data/Jobs/Job Data/"
	var dir = DirAccess.open( data_path )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") == true:
				var job: Job = load(
					data_path + "/" + file_name
				)
				character_jobs.append( job )
			file_name = dir.get_next()
		dir.list_dir_end()
