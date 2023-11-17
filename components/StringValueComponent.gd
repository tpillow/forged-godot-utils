class_name StringValueComponent
extends Node

signal valueChanged()

@export var value: String = "":
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
