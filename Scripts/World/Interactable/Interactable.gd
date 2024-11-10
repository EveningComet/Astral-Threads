## An object that the player can interact with.
class_name Interactable extends Node

## Fired when the player has interacted with this object. Anything that needs
## to know about this interaction needs to subscribe to this event.
signal interacted(interactable: Interactable)

func interact() ->  void:
	interacted.emit(self)
