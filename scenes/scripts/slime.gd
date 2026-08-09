class_name Slime
extends CharacterBody2D

var direction: Vector2
var player: CharacterBody2D
var see_player := false
var is_moving := false
var in_attack_area := false
var is_attacking := false

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
	if is_attacking:
		velocity = direction * attack_speed
		move_and_slide()
	elif is_moving:
		direction = (player.position - position).normalized()
		velocity = direction * basic_speed
		move_and_slide()
	animate()
	
func jump() -> void:
	is_moving = true
	await get_tree().create_timer(0.2).timeout
	is_moving = false
	
func attack() -> void:
	is_attacking = true
	await get_tree().create_timer(0.5).timeout
	is_attacking = false
	direction = (player.position - position).normalized()
	
func animate() -> void:
	var blend_pos = Vector2i(round(direction.x), round(direction.y))
	
	if see_player:
		move_state_machine.travel("Attack" if in_attack_area else "Move")
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", blend_pos)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", blend_pos)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Attack/blend_position", blend_pos)
		$Animation/AnimationTree.set("parameters/DeathStateMachine/Death/blend_position", blend_pos)
	else:
		move_state_machine.travel("Idle")

func discard_health(hlth: float):
	health -= hlth
	if health <= 0:
		basic_speed = 0
		attack_speed = 0
		$Animation/AnimationTree.set("parameters/OneShot/request", 
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		await $Animation/AnimationTree.animation_finished
		queue_free()

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

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body == player and is_attacking:
		player.discard_health(damage)
		
		var tween = create_tween()
		var sprite = player.get_node("Sprite")
		
		tween.tween_property(sprite.material, "shader_parameter/flash_factor", 1.0, 0.2)
		tween.tween_property(sprite.material, "shader_parameter/flash_factor", 0.0, 0.2)
