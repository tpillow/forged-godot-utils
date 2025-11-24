class_name ItemSlot
extends Resource

@export var _item: Item
var item: Item:
	get: return item

@export var _count: int = 0
var count: int:
	get: return count

func _init() -> void:
	_validate_count()

func _validate_count() -> void:
	if not item:
		assert(count == 0)
	else:
		assert(count > 0 and count <= item.max_stack_count)

@warning_ignore("shadowed_variable")
func set_item(item: Item, count: int) -> void:
	_item = item
	_count = count
	_validate_count()
	changed.emit()

func unset_item() -> void:
	set_item(null, 0)

func increment_count(amount: int = 1) -> void:
	assert(amount > 0)
	assert(item)
	assert(count + amount <= item.max_stack_count)
	_count += amount
	changed.emit()
	
func decrement_count(amount: int = 1) -> void:
	assert(amount > 0)
	assert(item)
	assert(count >= amount)
	_count -= amount
	if count == 0:
		unset_item()
	else:
		changed.emit()

static func swap(a: ItemSlot, b: ItemSlot) -> void:
	var tmp_item := a.item
	var tmp_count := a.count
	a.set_item(b.item, b.count)
	b.set_item(tmp_item, tmp_count)
