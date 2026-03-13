extends CanvasLayer

var hearts: Array[HeartGui] = []

func _ready() -> void:
  for child in $Control/HFlowContainer.get_children():
    if child is HeartGui:
      hearts.append(child)
      child.visible = false

func update_hp(hp: float, max_hp: float) -> void:
  update_max_hp(max_hp)
  for i in range(ceil(max_hp)):
    update_heart(i, hp)


func update_heart(index: int, hp: float) -> void:
   var value: int = clampi(hp - index * 2, 0, 2)
   hearts[index].value = value


func update_max_hp(max_hp: float) -> void:
  var heart_count: int = ceil(max_hp * 0.5)
  for i in range(hearts.size()):
    hearts[i].visible = (i < heart_count)
