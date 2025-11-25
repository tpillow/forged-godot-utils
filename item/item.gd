@abstract
class_name Item
extends Resource

@export var name := "":
	get: return name
	set(value):
		name = value
		changed.emit()

@export var description := "":
	get: return description
	set(value):
		description = value
		changed.emit()

@export var icon: Texture2D:
	get: return icon
	set(value):
		icon = value
		changed.emit()

@export var max_stack_count: int = 1:
	get: return max_stack_count
	set(value):
		max_stack_count = value
		assert(max_stack_count > 0)
		changed.emit()
