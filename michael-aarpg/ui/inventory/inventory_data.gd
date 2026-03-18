class_name InventoryData extends Resource

signal slot_removed(index: int)

@export var slots: Array[SlotData]

func _init() -> void:
  for i in range(slots.size()):
    var slot: SlotData = slots[i]
    if slot == null:
      continue

    slot.changed.connect(_on_slot_changed.bind(i))

func _on_slot_changed(index: int) -> void:
  if slots[index].quantity >= 1:
    return

  slots[index].changed.disconnect(_on_slot_changed.bind(index))
  slots[index] = null
  slot_removed.emit(index)
  


func add_item(item: ItemData, quantity: int = 1) -> bool:
  for slot in slots:
    if slot != null and slot.item == item:
      slot.quantity += quantity
      return true

  for i in slots.size():
    if slots[i] == null:
      slots[i] = SlotData.new()
      slots[i].item = item
      slots[i].quantity = quantity
      slots[i].changed.connect(_on_slot_changed.bind(i))
      return true

  return false
