## Stores data related to a job that a player character can have.
class_name CharacterJobButton extends Button

## Fired when the player selects a class that they want a character have.
signal job_button_pressed(jd: Job)

## Fired when the player is inspecting this class button.
signal job_button_focused(jd: Job)

## The attached job data.
var job_data: Job:
	get: return job_data
	set(value):
		job_data = value
		set_text(job_data.localization_name)

func _ready() -> void:
	pressed.connect( on_pressed )
	mouse_entered.connect( on_mouse_entered )
	focus_entered.connect( on_focused )

func on_pressed() -> void:
	job_button_pressed.emit(job_data)

func on_mouse_entered() -> void:
	job_button_focused.emit(job_data)

func on_focused() -> void:
	job_button_focused.emit(job_data)
