class_name Inventory
extends Resource

@export var item_slots: Array[ItemSlot]:
	get: return item_slots
	set(value):
		item_slots = value
		changed.emit()

var num_item_slots: int:
	get: return item_slots.size()
	
static func new_with_num_slots(num_slots: int) -> Inventory:
	var inv := Inventory.new()
	for i in range(num_slots):
		inv.item_slots.append(ItemSlot.new())
	return inv

func get_item_slots_with_item(item: Item) -> Array[ItemSlot]:
	return item_slots.filter(func(slot):
		return slot.item == item)

func get_num_of_item(item: Item) -> int:
	return get_item_slots_with_item(item).reduce(
		func(count: int, slot: ItemSlot):
			return count + slot.count,
		0)

func get_first_free_item_slot() -> ItemSlot:
	for slot in item_slots:
		if not slot.item:
			return slot
	return null

func can_add_item(item: Item) -> bool:
	var existing_slots := get_item_slots_with_item(item)
	for slot in existing_slots:
		if slot.count < item.max_stack_count:
			return true
	return get_first_free_item_slot() != null
	
func add_item(item: Item) -> void:
	assert(can_add_item(item))
	var existing_slots := get_item_slots_with_item(item)
	existing_slots.sort_custom(func(a, b): return a.count > b.count)
	for slot in existing_slots:
		if slot.count < item.max_stack_count:
			slot.increment_count(1)
			return
	var slot := get_first_free_item_slot()
	slot.set_item(item, 1)
	
func has_item(item: Item, min_count: int) -> bool:
	assert(min_count > 0)
	return get_num_of_item(item) >= min_count

func remove_item(item: Item, count: int) -> void:
	assert(has_item(item, count))
	var existing_slots := get_item_slots_with_item(item)
	existing_slots.sort_custom(func(a, b): return a.count < b.count)
	for slot in existing_slots:
		if slot.count < count:
			count -= slot.count
			slot.decrement_count(slot.count)
		else:
			slot.decrement_count(count)
			return
