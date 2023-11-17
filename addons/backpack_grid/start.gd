@tool
extends EditorPlugin

const accvv = "backpack_grid"

func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton(accvv,"res://addons/backpack_grid/Parameter_function.gd")
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(accvv)
	pass


