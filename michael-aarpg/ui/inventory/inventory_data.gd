class_name InventoryData extends Resource

signal slot_removed(index: int)

@export var slots: Array[SlotData]

func _init() -> void:
  for i in range(slots.size()):
    var slot: SlotData = slots[i]
    if slot == null:
      continue

    slot.changed.connect(_on_slot_changed.bind(i))

func reload(p_slots: Array[SlotData]) -> void:
  for i in range(p_slots.size()):
    slots[i] = p_slots[i]


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

func get_save_data() -> Array[Dictionary]:
  var save_data: Array[Dictionary] = []
  for slot in slots:
    save_data.append({
      "item": "" if slot == null else slot.item.resource_path,
      "quantity": 0 if slot == null else slot.quantity
    })
  return save_data

func load_save_data(save_data: Array) -> void:
  self.slots.clear()
  self.slots.resize(save_data.size())

  for i in range(save_data.size()):
    self.slots[i] = item_from_save(save_data[i])
    if self.slots[i] != null:
      self.slots[i].changed.connect(_on_slot_changed.bind(i))

func item_from_save(save_object: Dictionary) -> SlotData:
  if save_object.item == "":
    return null

  var new_slot: SlotData = SlotData.new()
  new_slot.item = load(save_object.item)
  new_slot.quantity = int(save_object.quantity)
  return new_slot
  
