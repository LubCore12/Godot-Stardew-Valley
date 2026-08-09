class_name Slime
extends CharacterBody2D

var direction: Vector2
var player: CharacterBody2D
var see_player := false
var is_moving := false
var in_attack_area := false

@onready var move_state_machine = \
	$Animation/AnimationTree.get("parameters/MoveStateMachine/playback") \
	as AnimationNodeStateMachinePlayback	

@export_group("Movement")
@export var basic_speed: float
@export var attack_speed: float

@export_group("Basic data")
@export var damage: float
@export var health: float

func setup(plr):
	player = plr

func _physics_process(_delta: float) -> void:
	direction = (player.position - position).normalized()
	if is_moving:
		velocity = direction * basic_speed
		move_and_slide()
	animate()
	
func jump() -> void:
	is_moving = true
	await get_tree().create_timer(0.2).timeout
	is_moving = false
	
func animate() -> void:
	var blend_pos = Vector2i(round(direction.x), round(direction.y))
	
	if see_player:
		move_state_machine.travel("Move")
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", blend_pos)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", blend_pos)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Attack/blend_position", blend_pos)
	else:
		move_state_machine.travel("Idle")

func _on_view_area_body_entered(body: 	Node2D) -> void:
	if body == player:
		see_player = true

func _on_view_area_body_exited(body: Node2D) -> void:
	if body == player:
		see_player = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == player:
		in_attack_area = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == player:
		in_attack_area = false
