class_name BasicTextOptionDialogue
extends PanelContainer

signal option_selected(option_index: int)

@onready var header_label: RichTextLabel = %HeaderLabel
@onready var content_label: RichTextLabel = %ContentLabel
@onready var vbox_options: VBoxContainer = %VBoxOptions
@onready var footer_label: RichTextLabel = %FooterLabel

var _cur_option_index: int = 0

static func instantiate_new() -> BasicTextOptionDialogue:
	return preload("res://forged_godot_utils/ui_nodes/basic_text_option_dialogue.tscn").instantiate()

func setup(header: String, content: String, options: Array[String], footer: String) -> void:
	header_label.text = header
	header_label.visible = header != ""
	content_label.text = content
	content_label.visible = content != ""
	footer_label.text = footer
	footer_label.visible = footer != ""
	
	vbox_options.visible = options.size() > 0
	NodeUtil.remove_all_children(vbox_options, true)
	for option in options:
		var opt_label := RichTextLabel.new()
		opt_label.bbcode_enabled = true
		opt_label.set_meta("option_text", option)
	_refresh_option_labels()

func _refresh_option_labels() -> void:
	for i in range(vbox_options.get_child_count()):
		var option_label: RichTextLabel = vbox_options.get_child(i)
		var text: String = option_label.get_meta("option_text")
		var prefix := "[color=green]> " if i == _cur_option_index else ""
		var suffix := "[/color]" if i == _cur_option_index else ""
		option_label.text = prefix + text
