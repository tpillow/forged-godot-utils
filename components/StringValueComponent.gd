class_name StringValueComponent
extends BasicComponent

signal valueChanged()

@export var value: String = "":
	get: return value
	set(newValue):
		if value == newValue:
			return
		value = newValue
		valueChanged.emit()
