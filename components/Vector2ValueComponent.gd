class_name Vector2ValueComponent
extends Node

signal valueChanged()

@export var value: Vector2 = Vector2.ZERO:
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
