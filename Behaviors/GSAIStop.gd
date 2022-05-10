# Calculated Acceleration to immediately stop the body
# @category - Individual behaviors
class_name GSAIStop
extends GSAISteeringBehavior

func _init(agent: GSAISteeringAgent).(agent) -> void:
	pass

func _calculate_steering(acceleration: GSAITargetAcceleration, delta = (1/60)) -> void:
	var vector = -agent.linear_velocity
	var impulse = agent.mass*vector
	acceleration.linear = GSAIUtils.clampedv3(impulse,agent.linear_acceleration_max*delta)
	if acceleration.linear == Vector3.ZERO:
		emit_signal("finished")
