extends CharacterBody3D

@onready var head: Node3D = $Head
@export var speed_walking = 5.0
@export var speed_sprinting = 8.0
@export var jump_veolcity = 4.5
const mouse_sensitivity = 0.25
var direction = Vector3.ZERO
var speed_current = 5.0
var speed_lerp = 10.0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion: 
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Sprinting
	if Input.is_action_pressed("sprint"):
		speed_current = speed_sprinting
	else:
		speed_current = speed_walking

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_veolcity

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * speed_lerp)
	if direction:
		velocity.x = direction.x * speed_current
		velocity.z = direction.z * speed_current
	else:
		velocity.x = move_toward(velocity.x, 0, speed_current)
		velocity.z = move_toward(velocity.z, 0, speed_current)

	move_and_slide()
