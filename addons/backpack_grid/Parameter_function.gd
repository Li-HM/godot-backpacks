extends Node

#===========以下定义背包参数==========
var backpack_position_xp:Vector2 = Vector2(700,100) #全局位置
var zz_index:int = 100    #渲染层级，为保证背包可见性，应尽量使该值加大
var grid_number:int = 100     #总格子的数量。注意，这个数值需要比你背包数组的长度大
var r_grid_number:int = 5    #每行格子的数量
var scroll_bar:bool = true     #滚动条
var item_grid_xp:Vector2 = Vector2(64,64)   #每个格子的大小像素
#替换成你的背包数组,数组元素为字典 必要键 "name","type","number","icon"
var item_array:Array = [{"name":"leaf","type":"crops","number":"1","icon":"00001"},{"name":"fruit","type":"crops","number":"2","icon":"00002"}]   #替换成你的背包数组,数组元素为字典。必要字段"name","type"
var item_icon_route:String =  "res://addons/backpack_grid/images/"  #背包物品图标,添加添加多个目录时，需要在加载背包创建图标时进行路径判断
var Background_image:String  = "res://icon.svg" #尽量使用绝对路径

#============背包功能变量============
var is_drag:bool = false  #当背包与其它容器交换物品时，通过该值来作为判断依据
var drag_item:Dictionary

#打开背包
func open_backpack():
#	判断，如果背包已经是打开的状态
	if has_node("/root/backpack_grid/backpack_background"):
		return
#	重新设置背包数组大小
	item_array.resize(grid_number)
#	实例化背包节点
	var backpack = preload("res://addons/backpack_grid/backpack_node.tscn").instantiate()
	backpack.name = "backpack_background"
	get_node("/root/backpack_grid").add_child(backpack)
	backpack.texture = load(Background_image)
#	设置背包控件的滚动条
	if scroll_bar:
		backpack.get_node("ScrollContainer").vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
	else :
		backpack.get_node("ScrollContainer").vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
#	设置背包控件的参数
	backpack.size = Vector2(r_grid_number*item_grid_xp.x + 25 ,400)
	backpack.get_node("ScrollContainer").size = Vector2(r_grid_number*item_grid_xp.x + 25 ,400)
	backpack.global_position = backpack_position_xp
	backpack.z_index = zz_index
	backpack.get_node("ScrollContainer/GridContainer").columns = r_grid_number
#	在背包控件中，根据背包大小实例化背包格子
	for i in grid_number:
		var grid = preload("res://addons/backpack_grid/grid_node.tscn").instantiate()
		grid.sort_id = i
		grid.custom_minimum_size = item_grid_xp
		backpack.get_node("ScrollContainer/GridContainer").add_child(grid)
#		背包格子生成后，把背包数组的物品加载到格子上
		if item_array.size() > i and item_array[i] != null :
			var items = preload("res://addons/backpack_grid/item_node.tscn").instantiate()
			grid.add_child(items)
			items.get_node("TextureRect").size = item_grid_xp - Vector2(2,2)
#			设置物品图标和显示名称
			if ResourceLoader.exists(item_icon_route + str(item_array[i]["icon"]) + str(".png")):
				items.get_node("TextureRect").texture = load(item_icon_route + str(item_array[i]["icon"]) + str(".png"))
			items.get_node("name").text = str(item_array[i]["name"])
#			如果图标上的数量或名称有位移或偏差，调整这里
			items.get_node("name").size = Vector2(item_grid_xp.x,26)
			items.get_node("name").position = Vector2(0,item_grid_xp.y-26)
#			print(item_array[i])
			if item_array[i].has("number"):
				items.get_node("number").text = str(item_array[i]["number"])
			else :
				items.get_node("number").text = ""


#关闭背包
func close_backpack():
#	关闭背包时，判断是不是有物品正被拖动
	if is_drag:
		get_items(drag_item)
	if !has_node("/root/backpack_grid/backpack_background"):
		return
	get_node("/root/backpack_grid/backpack_background").queue_free()


#获得物品。先判断背包中是否存在同类物品，如果存在且能叠加则进行叠加操作
func get_items(item:Dictionary):
#	print("执行到")
	var index:int = 0
	for i in item_array:
#		判断背包是否有同类物品
		if i != null and i["name"] == item["name"] and i["type"] == item["type"] :
			if item.has("number"):
				item_array[index]["number"] = str(int(i["number"]) + int(item["number"]))
#				叠加后更新数据显示
				if has_node("/root/backpack_grid/backpack_background/ScrollContainer/GridContainer"):
					get_node("/root/backpack_grid/backpack_background/ScrollContainer/GridContainer").get_child(index).get_child(0).get_child(1).text = str(item_array[index]["number"])
				return
			else :
				Add_items_to_array(item)
				return
		index += 1
	Add_items_to_array(item)


#添加物品，传入该物品的字典
func Add_items_to_array(item:Dictionary):
	var empty:int = item_array.find(null)
	if empty != -1:
		item_array[empty] = item
#		如果背包已打开，在背包显示刚添加的物品
		if has_node("/root/backpack_grid/backpack_background"):
			var items = preload("res://addons/backpack_grid/item_node.tscn").instantiate()
			for i in get_node("/root/backpack_grid/backpack_background/ScrollContainer/GridContainer").get_child_count():
				if get_node("/root/backpack_grid/backpack_background/ScrollContainer/GridContainer").get_child(i).sort_id == empty:
					get_node("/root/backpack_grid/backpack_background/ScrollContainer/GridContainer").get_child(i).add_child(items)
					items.get_node("TextureRect").size = item_grid_xp - Vector2(2,2)
		#			设置物品图标和显示名称
					if ResourceLoader.exists(item_icon_route + str(item_array[empty]["icon"]) + str(".png")):
						items.get_node("TextureRect").texture = load(item_icon_route + str(item_array[empty]["icon"]) + str(".png"))
					items.get_node("name").text = str(item_array[empty]["name"])
		#			如果图标上的数量或名称有位移或偏差，调整这里
					items.get_node("name").size = Vector2(item_grid_xp.x,26)
					items.get_node("name").position = Vector2(0,item_grid_xp.y-26)
					if item_array[empty].has("number"):
						items.get_node("number").text = str(item_array[empty]["number"])
					else :
						items.get_node("number").text = ""
	else :
		print("The backpack is full")

#拖动一个物品
func drag_items(sort_id):
	drag_item = item_array[sort_id]
	item_array[sort_id] = null
	is_drag = true



func Stack_replacing_items(this_item:Dictionary,sort:TextureRect):
#	判断是不是同名同类物品,且具有数量 "number" 键
	if this_item["name"] == drag_item["name"] and this_item["type"] == drag_item["type"] and drag_item.has("number"):
#		print("叠加")
		item_array[sort.sort_id]["number"] = str(int(this_item["number"]) + int(drag_item["number"]))
		drag_item = {}
		is_drag = false
#		更新叠加后的数据显示
		sort.get_node("item_node/number").text = str(item_array[sort.sort_id]["number"])
	else :
		is_drag = false
		sort.get_child(0).reparent(get_node("/root/backpack_grid/backpack_background"))
		item_array[sort.sort_id] = drag_item
		if has_node("/root/backpack_grid/item_node"):
			get_node("/root/backpack_grid/item_node").reparent(sort)
			sort.get_child(0).position = Vector2.ZERO
			sort.get_child(0).z_index = 0
		drag_item = this_item
		get_node("/root/backpack_grid/backpack_background/item_node").reparent(get_node("/root/backpack_grid"))
		get_node("/root/backpack_grid/item_node").z_index = zz_index + 2
		is_drag = true


#放下拖动的物品
func drop_items(sort:TextureRect):
	item_array[sort.sort_id] = drag_item
	is_drag = false
	if has_node("/root/backpack_grid/item_node"):
		get_node("/root/backpack_grid/item_node").reparent(sort)
		sort.get_child(0).position = Vector2.ZERO
		sort.get_child(0).z_index = 0



func _process(delta):
#	拖动物品跟随鼠标移动
	if is_drag and has_node("/root/backpack_grid/item_node"):
		get_node("/root/backpack_grid/item_node").global_position = get_viewport().get_mouse_position() - item_grid_xp/2





