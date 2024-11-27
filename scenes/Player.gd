extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
# var velocity = Vector3.ZERO
var stop = false


func _physics_process(delta):
	# main loop
	var direction = Vector3.ZERO
	
	# movement
	if not stop:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_backward"):
			direction.z += 1
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$CollisionShape3D.rotation = $Pivot.rotation
		
		# launch walk animation
		$Pivot/Fox/AnimationPlayer.play("2walk", -1, 4.0)
	else:
		# show idle animation
		$Pivot/Fox/AnimationPlayer.play("1idle")
		
	if Input.is_action_pressed("search"):
			$Pivot/Fox/AnimationPlayer.play("3rummage")
	
	if stop:
		$Pivot/Fox/AnimationPlayer.stop()
		
	# velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# vertical velocity
	velocity.y -= fall_acceleration * delta
	
	# move the character
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
