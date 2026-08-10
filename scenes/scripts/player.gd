class_name Player
extends CharacterBody2D

var direction: Vector2
var last_direction: Vector2 = Vector2.DOWN
var current_tool: Enum.Tool = Enum.Tool.AXE
var current_seed: Enum.Seed = Enum.Seed.TOMATO
var can_move := true

@onready var move_state_machine = \
	$Animation/AnimationTree.get("parameters/MoveStateMachine/playback") \
	as AnimationNodeStateMachinePlayback
@onready var tool_state_machine = \
	$Animation/AnimationTree.get("parameters/ToolStateMachine/playback") \
	as AnimationNodeStateMachinePlayback
@onready var animation_tree = $Animation/AnimationTree

@export_group("Movement")
@export var speed: float

@export_group("Basic data")
@export var health: float

signal tool_use(tool: Enum.Tool, pos: Vector2i)
signal player_damage(damage: float)

func _physics_process(_delta: float) -> void:
	if direction:
		last_direction = direction
		if last_direction.x != round(last_direction.x):
			last_direction.x = round(last_direction.x)
			last_direction.y = 0
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
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
		animation_tree.set("parameters/OneShot/request", 
									  AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		can_move = false
		await animation_tree.animation_finished
		can_move = true
		
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var tool_axis = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + tool_axis, Enum.Tool.size()) as Enum.Tool
		
	if Input.is_action_just_pressed("seed_forward"):
		current_seed = posmod(current_seed + 1, Enum.Seed.size()) as Enum.Seed

func animate() -> void:
	var target_vector = Vector2i(round(direction.x), round(direction.y))
	
	if direction.length():
		move_state_machine.travel("Move")
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", target_vector)
		animation_tree.set("parameters/MoveStateMachine/Move/blend_position", target_vector)
		
		for tool in Data.TOOL_STATE_ANIMATIONS.values():
			animation_tree.set("parameters/ToolStateMachine/{tool}/blend_position".format({"tool": tool}), target_vector)
	else:
		move_state_machine.travel("Idle")
		
func discard_health(damage: float):
	health -= damage
	player_damage.emit(damage)

func get_grid_pos() -> Vector2i:
	return Vector2i(
		round((position.x + last_direction.x * 20 - Data.HALF_TILE_SIZE) / Data.TILE_SIZE), 
		round((position.y + last_direction.y * 20 - Data.HALF_TILE_SIZE) / Data.TILE_SIZE)
	)

func tool_use_emit():
	tool_use.emit(current_tool, current_seed, position, get_grid_pos())
