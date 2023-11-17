class_name BoolValueComponent
extends Node

signal valueChanged()

@export var value: bool = false:
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
