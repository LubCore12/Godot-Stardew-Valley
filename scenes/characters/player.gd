class_name Player
extends CharacterBody2D

var direction: Vector2

@onready var move_state_machine = \
	$Animation/AnimationTree.get("parameters/MoveStateMachine/playback") \
	as AnimationNodeStateMachinePlayback

@export_group("Movement")
@export var speed: float

func _physics_process(_delta: float) -> void:
	get_input()
	move()
	animate()
	
func move() -> void:
	velocity = direction * speed
	move_and_slide()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

func animate() -> void:
	var target_vector = Vector2i(round(direction.x), round(direction.y))
	
	if direction.length():
		move_state_machine.travel("Move")
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", target_vector)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", target_vector)
	else:
		move_state_machine.travel("Idle")

func tool_use_emit():
	print('tool')
