## Responsible for accessing and storing various data in the game.
extends Node

const MALE:   String = "MALE"
const FEMALE: String = "FEMALE"
const UNISEX: String = "UNISEX"

var character_jobs: Array[Job] = []
var char_names: Dictionary = {}

func _ready() -> void:
	load_jobs()
	load_character_names()

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

func load_character_names() -> void:
	char_names[MALE]   = []
	char_names[FEMALE] = []
	char_names[UNISEX] = []
	
	var char_names_path: String = "res://Game Data/Character Names/Character Names.csv"
	var file = FileAccess.open(char_names_path, FileAccess.READ)
	while file.eof_reached() == false:
		var csv = file.get_csv_line()
		
		if csv[0] != MALE and csv[0] != "":
			char_names[MALE].append(csv[0])
		
		if csv.size() > 1:
			if csv[1] != FEMALE and csv[1] != "":
				char_names[FEMALE].append(csv[1])
		
		if csv.size() > 2:
			if csv[2] != UNISEX and csv[2] != "":
				char_names[UNISEX].append(csv[2])
	
	file.close()

func get_male_name() -> String:
	var potential_names: PackedStringArray = char_names[MALE]
	potential_names.append_array(char_names[UNISEX])
	var index: int = randi_range(0, potential_names.size() - 1)
	var chosen_name: String = potential_names[index]
	return chosen_name

func get_female_name() -> String:
	var potential_names: PackedStringArray = char_names[FEMALE]
	potential_names.append_array(char_names[UNISEX])
	var index: int = randi_range(0, potential_names.size() - 1)
	var chosen_name: String = potential_names[index]
	return chosen_name
