class_name InventorySlot extends Button

var slot_data: SlotData: set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
  texture_rect.texture = null
  label.text = ""

  focus_entered.connect(_on_item_focused)
  focus_exited.connect(_on_item_unfocused)
  pressed.connect(_on_item_pressed)


func set_slot_data(p_slot_data: SlotData) -> void:
  slot_data = p_slot_data
  if p_slot_data == null:
    return

  texture_rect.texture = p_slot_data.item.texture
  label.text = str(p_slot_data.quantity)


func _on_item_focused() -> void:
  if slot_data == null or slot_data.item == null:
    PauseMenu.update_item_description("")
    return
    
  PauseMenu.update_item_description(slot_data.item.description)

func _on_item_unfocused() -> void:
  PauseMenu.update_item_description("")

func _on_item_pressed() -> void:
  if slot_data == null or slot_data.item == null:
    return

  if not slot_data.item.use():
    return

  slot_data.quantity -= 1
  label.text = str(slot_data.quantity)