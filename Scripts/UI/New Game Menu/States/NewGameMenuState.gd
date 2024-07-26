## Defines what the new game menu can do at a single point in time.
class_name NewGameMenuState extends State

## Some states will need to make sure the object holding the displayed
## party is hidden.
@export var active_party_container: Container

## Some states will need to display things to the player.
@export var description_displayer: DescriptionDisplayer
