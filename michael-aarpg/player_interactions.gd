class_name PlayerInteractions extends Node2D

@onready var player: Player = $".."

func _ready() -> void:
  player.direction_changed.connect(_update_direction)

func _update_direction(new_direction: Vector2) -> void:
  match new_direction:
    Vector2.DOWN:
      self.rotation_degrees = 0
    Vector2.UP:
      self.rotation_degrees = 180
    Vector2.LEFT:
      self.rotation_degrees = 90
    Vector2.RIGHT:
      self.rotation_degrees = -90
    _:
      self.rotation_degrees = 0