class_name Player
extends CharacterBody2D

var direction: Vector2
var current_tool: Enum.Tool
var can_move := true

const TOOL_COLLECTION = {
	Enum.Tool.AXE: "Axe",
	Enum.Tool.HOE: "Hoe",
	Enum.Tool.WATER: "Water",
	Enum.Tool.FISH: "Fish",
	Enum.Tool.SEED: "Seed",
	Enum.Tool.SWORD: "Sword"
}

@onready var move_state_machine = \
	$Animation/AnimationTree.get("parameters/MoveStateMachine/playback") \
	as AnimationNodeStateMachinePlayback
	
@onready var tool_state_machine = \
	$Animation/AnimationTree.get("parameters/ToolStateMachine/playback") \
	as AnimationNodeStateMachinePlayback

@export_group("Movement")
@export var speed: float

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
		move()
	animate()
	
func move() -> void:
	velocity = direction * speed
	move_and_slide()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel("Fish")
		$Animation/AnimationTree.set("parameters/OneShot/request", 
									  AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
		await $Animation/AnimationTree.animation_finished
		can_move = true

func animate() -> void:
	var target_vector = Vector2i(round(direction.x), round(direction.y))
	
	if direction.length():
		move_state_machine.travel("Move")
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", target_vector)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", target_vector)
		
		for tool in TOOL_COLLECTION.values():
			$Animation/AnimationTree.set("parameters/ToolStateMachine/{tool}/blend_position".format({"tool": tool}), target_vector)
			
	else:
		move_state_machine.travel("Idle")

func tool_use_emit():
	print('tool')
