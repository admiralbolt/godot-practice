@tool
class_name TreasureChest extends Node

@export var item_data: ItemData: set = _set_item_data
@export var quantity: int = 1: set = _set_quantity

var is_open: bool = false

@onready var sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D

func _ready() -> void:
  _update_label()
  _update_texture()

  if Engine.is_editor_hint():
    return

  self.interact_area.area_entered.connect(_on_area_entered)
  self.interact_area.area_exited.connect(_on_area_exited)

func player_interact() -> void:
  if self.is_open:
    return

  self.is_open = true
  self.animation_player.play("open_chest")
  if self.item_data and self.quantity > 0:
    PlayerManager.INVENTORY_DATA.add_item(self.item_data, self.quantity)


func _on_area_entered(_area: Area2D) -> void:
  PlayerManager.interact_pressed.connect(player_interact)
  return

func _on_area_exited(_area: Area2D) -> void:
  PlayerManager.interact_pressed.disconnect(player_interact)
  return

func _set_quantity(p_quantity: int) -> void:
  quantity = p_quantity
  _update_label()

func _update_label() -> void:
  if not self.label:
    return

  self.label.text = "x%s" % quantity
  self.label.visible = quantity > 1

func _set_item_data(p_item_data: ItemData) -> void:
  item_data = p_item_data
  _update_texture()
  return

func _update_texture() -> void:
  if self.item_data and self.sprite:
    self.sprite.texture = self.item_data.texture

