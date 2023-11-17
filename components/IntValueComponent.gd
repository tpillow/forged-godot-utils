class_name IntValueComponent
extends Node

signal valueChanged()

@export var value: int = 0:
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
