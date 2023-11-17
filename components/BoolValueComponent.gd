class_name BoolValueComponent
extends BasicComponent

signal valueChanged()

@export var value: bool = false:
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
