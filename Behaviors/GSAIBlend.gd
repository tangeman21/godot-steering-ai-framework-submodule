# Blends multiple steering behaviors into one, and returns a weighted
# acceleration from their calculations.
#
# Stores the behaviors internally as dictionaries of the form
# {
# 	behavior : GSAISteeringBehavior,
# 	weight : float
# }
# @category - Combination behaviors
class_name GSAIBlend
extends GSAISteeringBehavior

var _behaviors := []
var _accel := GSAITargetAcceleration.new()

var _remove_list :=[]


func _init(agent: GSAISteeringAgent).(agent) -> void:
	pass


# Appends a behavior to the internal array along with its `weight`.
func add(behavior: GSAISteeringBehavior, weight: float) -> void:
	behavior.agent = agent
	_behaviors.append({behavior = behavior, weight = weight})

func _remove() -> void:
	for beh in _remove_list:
		var to_remove
		for behavior_dict in _behaviors:
			if behavior_dict.behavior == beh:
				to_remove = behavior_dict
		_behaviors.erase(to_remove)
	_remove_list.clear()

func remove(behavior: GSAISteeringBehavior) -> void:
	_remove_list.append(behavior)

# Returns the behavior at the specified `index`, or an empty `Dictionary` if
# none was found.
func get_behavior_at(index: int) -> Dictionary:
	if _behaviors.size() > index:
		return _behaviors[index]
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	return {}


func _calculate_steering(blended_accel: GSAITargetAcceleration, delta : float) -> void:
	self._remove()
	blended_accel.set_zero()

	for i in range(_behaviors.size()):
		var bw: Dictionary = _behaviors[i]
		#print(delta)
		bw.behavior.calculate_steering(_accel,delta)

		blended_accel.add_scaled_accel(_accel, bw.weight)

	blended_accel.linear = GSAIUtils.clampedv3(blended_accel.linear, agent.linear_acceleration_max)
	blended_accel.angular = clamp(
		blended_accel.angular, -agent.angular_acceleration_max*agent.inertia, agent.angular_acceleration_max*agent.inertia
	)
