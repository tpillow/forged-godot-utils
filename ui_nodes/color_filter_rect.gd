@tool
class_name ColorFilterRect
extends ColorRect

# Must match color_filter.gdshader MAX_PALETTE_SIZE
const MAX_PALETTE_SIZE := 10

@export var palette: Array[Color] = [Color.BLACK, Color.DIM_GRAY, Color.WHITE]:
	get: return palette
	set(value):
		palette = value
		_refresh()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	material = ShaderMaterial.new()
	material.shader = preload("res://forged_godot_utils/shaders/color_filter.gdshader").duplicate(true)
	_refresh()
	
func _refresh() -> void:
	if not is_node_ready(): return
	assert(palette.size() > 0 and palette.size() <= MAX_PALETTE_SIZE)
	
	var full_palette: Array[Color]
	full_palette.resize(MAX_PALETTE_SIZE)
	full_palette.fill(Color.RED)
	for i in range(palette.size()):
		full_palette[i] = palette[i]
	
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("palette_size", palette.size())
	mat.set_shader_parameter("palette", PackedColorArray(full_palette))
