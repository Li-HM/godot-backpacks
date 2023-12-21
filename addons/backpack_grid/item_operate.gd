extends BoxContainer


#丢弃物品
func _on_button_button_down():
	#print("丢弃物品")
	#删除背包数组数据
	backpack_grid.item_array[backpack_grid.item_index] = null
	#删除物品图标
	backpack_grid.item_grid.get_child(0).queue_free()
	#关闭功能菜单
	backpack_grid.is_operate.queue_free()
