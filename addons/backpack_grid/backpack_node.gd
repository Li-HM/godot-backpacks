extends TextureRect

#鼠标滚动时，关闭详情页
func _on_scroll_container_gui_input(event):
	if event is InputEventMouseButton:
#		左键点击
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if has_node("/root/backpack_grid/item_info"):
				get_node("/root/backpack_grid/item_info").free()
