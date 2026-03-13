class_name HeartGui extends Control

@onready var sprite: Sprite2D = $Sprite2D

var value: int = 2: set = set_value

func set_value(p_value: int):
  value = p_value
  sprite.frame = value