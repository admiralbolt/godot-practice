@tool
class_name ItemPickup extends CharacterBody2D

@export var item_data: ItemData: set = _set_item_data

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
  _update_texture()
  if Engine.is_editor_hint():
    return

  area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
  var collision_info: KinematicCollision2D = move_and_collide(velocity * delta)
  if collision_info:
    velocity = velocity.bounce(collision_info.get_normal())
  velocity -= velocity * delta * 4


func _on_body_entered(body: Node) -> void:
  if body is not Player:
    return

  if not item_data:
    return

  if not PlayerManager.INVENTORY_DATA.add_item(item_data, 1):
    return

  area.body_entered.disconnect(_on_body_entered)
  audio_stream_player.play()
  visible = false
  await audio_stream_player.finished
  queue_free()
  

func _update_texture() -> void:
  if item_data == null or sprite == null:
    return

  sprite.texture = item_data.texture

func _set_item_data(p_item_data: ItemData) -> void:
  item_data = p_item_data
  _update_texture()