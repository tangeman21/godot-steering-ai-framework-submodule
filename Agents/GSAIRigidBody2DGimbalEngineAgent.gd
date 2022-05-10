# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody2D
# @category - Specialized agents
extends GSAIRigidBody2DAgent
class_name GSAIRigidBody2DGimbalEngineAgent

var maneuver_acceleration_max := 0.0

# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration: GSAITargetAcceleration, _delta: float) -> void:
	var _body: RigidBody2D = _body_ref.get_ref()
	if not _body:
		return

	_applied_steering = true
	
	var main_thruster_thrust = GSAIUtils.to_vector2(acceleration.linear).project(GSAIUtils.angle_to_vector2(self.orientation))
	var maneuver_thruster_thrust = GSAIUtils.clampedv3(acceleration.linear,maneuver_acceleration_max)
	_body.apply_central_impulse(GSAIUtils.to_vector2(main_thruster_thrust+maneuver_thruster_thrust))
	_body.apply_torque_impulse(acceleration.angular)
	if calculate_velocities:
		linear_velocity = GSAIUtils.to_vector3(_body.linear_velocity)
		angular_velocity = _body.angular_velocity
