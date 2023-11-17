class_name FloatValueComponent
extends Node

signal valueChanged()

@export var value: float = 0.0:
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
