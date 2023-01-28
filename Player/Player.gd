extends KinematicBody2D

const ACCELERATION = 600;
const MAX_SPEED = 130;
const FRICTION = 400;

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state
var velocity = Vector2.ZERO;

onready var animationPlayer = $AnimationPlayer;
onready var animationTree = $AnimationTree;
onready var animationState = animationTree.get("parameters/playback")

#called after the game is playing
func _ready():
	animationTree.active = true;
	
# Called every frame. 'delta' is the elapsed time since the previous frame (depends on the computer).
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO;
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized();
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector);
		animationTree.set("parameters/Run/blend_position", input_vector);
		animationState.travel("Run");
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta);
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta);
	
	# WHY is it velocity * delta * MAX_SPEED? 
	# Because if we move the scene it will get laggy if the computer is slower if 
	# its not multiplied by delta, but only having delta multiplier will make the 
	# character so slow, so we need to implement a constant to make it moves faster 
	# by multiplying it with MAX_SPEED
	print("velocity", velocity);
	velocity = move_and_slide(velocity);
	
func attack_state(delta):
	pass
