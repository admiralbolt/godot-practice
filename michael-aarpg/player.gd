class_name Player extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var move_speed: float = 100.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_effect: Sprite2D = %AttackEffectSprite
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
  animation_tree.active = true

func _process(_delta: float) -> void:
  direction = Input.get_vector("left", "right", "up", "down")
  var is_attacking: bool = Input.is_action_pressed("attack")

  animation_tree.set("parameters/conditions/attack", is_attacking)
  
  update_blend_position()

func _is_attacking() -> bool:
  return animation_tree.get("parameters/playback").get_current_node() == "attack"

func _physics_process(_delta: float) -> void:
  velocity = direction * move_speed
  if _is_attacking():
    velocity *= 0.66
  move_and_slide()

func update_blend_position() -> void:
  if direction == Vector2.ZERO or _is_attacking():
    return

  animation_tree.set("parameters/idle/blend_position", direction)
  animation_tree.set("parameters/walk/blend_position", direction)
  animation_tree.set("parameters/attack/attack/blend_position", direction)
  animation_tree.set("parameters/attack/attack_effect/blend_position", direction)
  sprite.scale.x = -1 if direction.x < 0 else 1
  attack_effect.scale.x = -1 if direction.x < 0 else 1
