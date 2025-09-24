## A version of the combatant component that keeps track of data relevant to
## player characters.
class_name PlayerCombatant extends Combatant

# TODO: Multiclassing.
var curr_job: Job

var equipment_holder: EquipmentHolder = EquipmentHolder.new(self)
