class_name Player extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var move_speed: float = 100.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
  animation_tree.active = true

func _process(_delta: float) -> void:
  direction = Input.get_vector("left", "right", "up", "down")

  if direction != Vector2.ZERO:
    update_blend_position()

func _physics_process(_delta: float) -> void:
  velocity = direction * move_speed
  move_and_slide()

func update_blend_position() -> void:
  animation_tree.set("parameters/idle/blend_position", direction)
  animation_tree.set("parameters/walk/blend_position", direction)
  sprite.scale.x = -1 if direction.x < 0 else 1
