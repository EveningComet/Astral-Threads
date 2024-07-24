## Stores data related to a job that a player character can have.
class_name CharacterJobButton extends Button

## Fired when the player selects a class that they want a character have.
signal job_button_pressed(jd: Job)

## The attached job data.
var job_data: Job:
	get: return job_data
	set(value):
		job_data = value
		set_text(job_data.localization_name)

func _ready() -> void:
	pressed.connect( on_pressed )

func on_pressed() -> void:
	job_button_pressed.emit(job_data)
