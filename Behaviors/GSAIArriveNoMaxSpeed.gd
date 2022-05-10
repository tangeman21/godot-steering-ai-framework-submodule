# Calculates acceleration to take an agent to its target's location. The
# calculation attempts to arrive with zero remaining velocity.
# @category - Individual behaviors
class_name GSAIArriveNoMaxSpeed
extends GSAISteeringBehavior

# Target agent to arrive to.
var target: GSAIAgentLocation
# Distance from the target for the agent to be considered successfully
# arrived.
var arrival_tolerance: float
# Distance from the target for the agent to begin slowing down.
var deceleration_radius: float
# Represents the time it takes to change acceleration.
var max_velocity: float


func _init(agent: GSAISteeringAgent, _target: GSAIAgentLocation).(agent) -> void:
	self.target = _target
	var to_target := _target.position - agent.position
	var distance := to_target.length()
	deceleration_radius = distance*(2.5/9.0)
	max_velocity = sqrt(distance*4/(7*(agent.linear_acceleration_max/agent.mass)))*(agent.linear_acceleration_max/agent.mass)

func _arrive(acceleration: GSAITargetAcceleration, target_position: Vector3, delta : float) -> void:
	var to_target := target_position - agent.position
	var distance := to_target.length()
	var desired_speed : float
	if distance <= arrival_tolerance:
		desired_speed = 0
	else:
		desired_speed = max_velocity
	if distance <= deceleration_radius:
		desired_speed *= distance / deceleration_radius

	var desired_velocity := to_target * desired_speed / distance
	desired_velocity = ((desired_velocity - agent.linear_velocity) * 1.0)
	acceleration.linear = GSAIUtils.clampedv3(desired_velocity, agent.linear_acceleration_max*delta)
	acceleration.angular = 0
	if acceleration.linear == Vector3.ZERO and distance <= arrival_tolerance:
		emit_signal("finished")


func _calculate_steering(acceleration: GSAITargetAcceleration, delta : float) -> void:
	_arrive(acceleration, target.position,delta)
