extends Node3D

var thrust_impulse: float = 15    # Adjust impulse strength as needed
var rotation_speed: float = 1
var thrust_active: bool = false

@onready var thruster_body: RigidBody3D = $RigidBody3D2  # Bottom part that rotates
@onready var main_body: RigidBody3D = $RigidBody3D      # Top part (main body)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Toggle thrust on/off with spacebar
	if Input.is_action_just_pressed("ui_select"):  # Spacebar
		thrust_active = !thrust_active
		

func _physics_process(delta: float) -> void:
	# Handle rotation controls using torques
	var rotation_input = Vector3.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):    # W key
		rotation_input.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):  # S key
		rotation_input.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):  # A key
		rotation_input.z -= 1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D): # D key
		rotation_input.z += 1
	
	# Apply rotation to thruster
	if rotation_input != Vector3.ZERO:
		var rotation = rotation_input.normalized() * rotation_speed * delta
		thruster_body.rotate_x(rotation.x)
		thruster_body.rotate_z(rotation.z)
	
	# Apply continuous impulse when thrust is active
	if thrust_active:
		# Get the direction the thruster is pointing (negative Y as it points down)
		var thrust_direction = thruster_body.global_transform.basis.y
		$RigidBody3D2/GPUParticles3D.emitting = true
		# Apply impulse
		var impulse_vector = thrust_direction * thrust_impulse
		main_body.apply_central_impulse(impulse_vector)
	else:
		$RigidBody3D2/GPUParticles3D.emitting = false
