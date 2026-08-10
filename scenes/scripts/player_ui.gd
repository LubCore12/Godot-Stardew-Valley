extends Control

@onready var health_bar = $TopLeftUI/HealthBar

func damage(value: float):
	health_bar.value -= value
