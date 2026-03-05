class_name LevelTileMap extends TileMapLayer

func _ready() -> void:
  var bounds: Array[Vector2] = []
  var used_rect: Rect2 = get_used_rect()
  bounds.append(Vector2(used_rect.position * rendering_quadrant_size))
  bounds.append(Vector2(used_rect.end * rendering_quadrant_size))

  LevelManager.change_tilemap_bounds(bounds)
