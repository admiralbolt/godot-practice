class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://ui/inventory/InventorySlot.tscn")

@export var data: InventoryData

func _ready() -> void:
  PauseMenu.shown.connect(self.update_inventory)
  PauseMenu.hidden.connect(self.clear)
  self.clear()
  self.data.slot_removed.connect(_on_slot_removed)

func clear() -> void:
  for child in get_children():
    child.queue_free()

func update_inventory() -> void:
  for slot in data.slots:
    var new_slot: InventorySlot = INVENTORY_SLOT.instantiate()
    add_child(new_slot)
    new_slot.set_slot_data(slot)

  get_child(0).grab_focus()

func _on_slot_removed(index: int) -> void:
  remove_child(get_child(index))
  var empty_slot: InventorySlot = INVENTORY_SLOT.instantiate()
  add_child(empty_slot)
  move_child(empty_slot, index)
  empty_slot.grab_focus()

