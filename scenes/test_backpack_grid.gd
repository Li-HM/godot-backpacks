extends Node2D


func _on_open_test_backpack_button_down():
	backpack_grid.open_backpack()


func _on_close_backpack_button_down():
	backpack_grid.close_backpack()


func _on_add_items_button_down():
	var aaa:Dictionary = {"name":"牛牛牛","type":"其他","number":1,"icon":null}
	backpack_grid.get_items(aaa)


func _on_view_array_button_down():
	print(backpack_grid.item_array)
	print("---------------")
