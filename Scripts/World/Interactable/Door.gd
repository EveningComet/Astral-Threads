## An [Interactee] object that opens and closes.
class_name Door extends Interactee

@export var opened: bool = false
@onready var _animation_tree: AnimationTree = get_parent().get_node("AnimationTree")
var _playback: AnimationNodeStateMachinePlayback

var _open:  String = "Open"
var _close: String = "Close"

func _ready() -> void:
	_playback = _animation_tree.get("parameters/playback")

func _on_interacted(interactable: Interactable) -> void:
	super(interactable)
	if opened == true:
		_playback.travel(_close)
	else:
		_playback.travel(_open)
	opened = !opened
