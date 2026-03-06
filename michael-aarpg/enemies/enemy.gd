class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box: HurtBox)
signal enemy_destroyed(hurt_box: HurtBox)

@export var health: float = 5.0

var direction : Vector2 = Vector2.ZERO
var direction_string: String = "down"
var invincible : bool = false
var player: Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
  state_machine.initialize(self)
  player = PlayerManager.player
  hit_box.Damaged.connect(_take_damage)

func _physics_process(_delta: float) -> void:
  move_and_slide()

func set_direction(new_direction: Vector2) -> bool:
  direction = new_direction
  if direction == Vector2.ZERO:
    return false

  if abs(direction.x) > abs(direction.y):
    direction_string = "side"
  elif direction.y < 0:
    direction_string = "up"
  else:
    direction_string = "down"
  
  emit_signal("direction_changed", new_direction)
  sprite.scale.x = -1 if direction.x < 0 else 1
  return true

func update_animation(state: String) -> void:
  animation_player.play(state + "_" + direction_string)

func _take_damage(hurt_box: HurtBox) -> void:
  if invincible:
    return
  
  health -= hurt_box.damage
  if health > 0:
    enemy_damaged.emit(hurt_box)
  else:
    enemy_destroyed.emit(hurt_box)