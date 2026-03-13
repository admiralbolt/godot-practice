class_name Player extends CharacterBody2D

signal player_damaged(hurt_box: HurtBox)

var direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.DOWN
var facing: Vector2 = Vector2.DOWN
var move_speed: float = 100.0
var invincible: bool = false
var health: float = 6
var max_health: float = 6

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_effect: Sprite2D = %AttackEffectSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_effect_player: AnimationPlayer = $AttackEffectPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var interactions: Node2D = $Interactions
@onready var hurt_box: HurtBox = %AttackHurtBox
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

func _ready() -> void:
  state_machine.initialize(self)
  PlayerManager.player = self
  update_health(99)
  hit_box.Damaged.connect(_take_damage)

func _process(_delta: float) -> void:
  direction = Input.get_vector("left", "right", "up", "down")
  if direction == Vector2.ZERO:
    return

  facing = direction

func _physics_process(_delta: float) -> void:
  move_and_slide()

func set_direction() -> bool:
  if direction == Vector2.ZERO:
    return false
   
  var new_dir: Vector2 = cardinal_direction

  if direction.y == 0:
    new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
  elif direction.x == 0:
    new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN

  if new_dir == cardinal_direction:
    return false

  cardinal_direction = new_dir
  sprite.scale.x = -1 if cardinal_direction.x < 0 else 1
  attack_effect.scale.x = -1 if cardinal_direction.x < 0 else 1
  interactions.scale.x = -1 if cardinal_direction.x < 0 else 1
  return true

func _animation_direction() -> String:
  if cardinal_direction == Vector2.DOWN:
    return "down"
  elif cardinal_direction == Vector2.UP:
    return "up"
  else:
    return "side"

func update_animation(state: String) -> void:
  animation_player.play(state + "_" + _animation_direction())
  # Hack to see.
  if state == "attack":
    attack_effect_player.play("attack_effect_" + _animation_direction())

func _take_damage(p_hurt_box: HurtBox) -> void:
  if invincible:
    return
      
  update_health(-p_hurt_box.damage)
  if health > 0:
    player_damaged.emit(p_hurt_box)
  else:
    player_damaged.emit(p_hurt_box)
    update_health(99)

func update_health(delta: float) -> void:
  health = clamp(health + delta, 0, max_health)
  PlayerHud.update_hp(health, max_health)

func make_invincible(duration: float = 1.0) -> void:
  invincible = true
  hit_box.monitoring = false
  
  await get_tree().create_timer(duration).timeout
  invincible = false
  hit_box.monitoring = true