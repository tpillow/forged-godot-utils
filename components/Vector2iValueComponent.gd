class_name Vector2iValueComponent
extends BasicComponent

signal valueChanged()

@export var value: Vector2i = Vector2i.ZERO:
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
