class_name SlotData extends Resource

@export var item: ItemData
@export var quantity: int: set = set_quantity

func set_quantity(value: int) -> void:
  quantity = value
  if quantity < 1:
    emit_changed()

