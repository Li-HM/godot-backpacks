extends TextureRect

var sort_id:int

#鼠标经过
func _on_mouse_entered():
	show_items_info()


#鼠标离开
func _on_mouse_exited():
#	关闭详情页
	if has_node("/root/backpack_grid/item_info"):
		get_node("/root/backpack_grid/item_info").free()


#鼠标点击事件
func _on_gui_input(event):
	if event is InputEventMouseButton:
		#背包被点击时，删除功能菜单栏
		if backpack_grid.is_operate != null :
			backpack_grid.is_operate.queue_free()
		
#		判断,如果没有正在拖动的物品，且格子上有物品  拖动
		if !backpack_grid.is_drag and self.get_child_count() != 0:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
#				print("拖动物品")
				backpack_grid.drag_items(sort_id)
#				在背包里删掉详情页，移动被拖动物品的图标
				if has_node("/root/backpack_grid/item_info"):
					get_node("/root/backpack_grid/item_info").free()
				if self.get_child_count() != 0:
					self.get_child(0).reparent(get_node("/root/backpack_grid"))
#					修改这个节点的显示图层顺序
					if backpack_grid.is_drag and has_node("/root/backpack_grid/item_node"):
						get_node("/root/backpack_grid/item_node").z_index = backpack_grid.zz_index +2 
#			右键点击
			if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
#				关闭详情页
				_on_mouse_exited()
				#鼠标右键点击事件，用来进行道具使用等功能.弹出功能菜单
				item_operate()
#		判断,如果有正在拖动的物品，且格子上有物品  叠加替换
		elif backpack_grid.is_drag and self.get_child_count() != 0:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
				backpack_grid.Stack_replacing_items(backpack_grid.item_array[sort_id],self)
#		判断,如果有正在拖动的物品，且格子上没有物品  放下拖动。
		elif backpack_grid.is_drag and self.get_child_count() == 0:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
				backpack_grid.drop_items(self)


#显示物品详情页
func show_items_info():
#	打开详情页.判断子节点不为 0 表示格子上有物品
	if self.get_child_count() != 0 and !has_node("/root/backpack_grid/item_info") and !backpack_grid.is_drag:
		var attribute = preload("res://addons/backpack_grid/item_info.tscn").instantiate()
		get_node("/root/backpack_grid").add_child(attribute)
		attribute.global_position = self.global_position + backpack_grid.item_grid_xp/1.3
		attribute.z_index = backpack_grid.zz_index+1
		for i in backpack_grid.item_array[sort_id]:
			#如果有更多不需要显示的项，在这里添加判断  or
			if i != "icon" :
				var type = attribute.get_node("BoxContainer/name").duplicate()
				type.text = str(backpack_grid.item_array[sort_id][i])
				attribute.get_node("BoxContainer").add_child(type)
		attribute.size.y = (26 + attribute.get_node("BoxContainer").get_child_count() * 26)


#显示物品功能菜单
func item_operate():
	if self.get_child_count() != 0 and !has_node("/root/backpack_grid/item_info") and !backpack_grid.is_drag:
		var oper = preload("res://addons/backpack_grid/item_operate.tscn").instantiate()
		self.get_parent().get_parent().get_parent().add_child(oper)
		#用变量记录节点，以方便删除
		backpack_grid.is_operate = oper
		#记录被操作道具的索引
		backpack_grid.item_index = self.sort_id
		#记录这个格子底座
		backpack_grid.item_grid = self
		oper.global_position = self.global_position + backpack_grid.item_grid_xp/2
		oper.z_index = backpack_grid.zz_index+2
