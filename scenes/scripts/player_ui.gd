extends Control

@onready var health_bar = $TopLeftUI/HealthBar
@onready var current_tool = $TopLeftUI/CurrentContainer/CurrentTool
@onready var current_seed = $TopLeftUI/CurrentContainer/CurrentSeed

func _ready() -> void:
	current_tool.texture = Data.TOOL_STATE_TEXTURES[Data.starting_tool]
	current_seed.texture = Data.PLANT_DATA[Data.starting_seed]["icon_texture"]

func damage(value: float) -> void:
	health_bar.value -= value
	
func set_tool(tool: Enum.Tool) -> void:
	current_tool.texture = Data.TOOL_STATE_TEXTURES[tool]
	
func set_seed(enum_seed: Enum.Seed) -> void:
	current_seed.texture = Data.PLANT_DATA[enum_seed]["icon_texture"]
