# godot - backpacks
Quickly building backpacks with godot

You need to modify the array in  backpack_grid/Parameter_function.gd  item_array to the array in your backpack

The following are the relevant functional methods：

Alt B:  backpack_grid.open_backpack()

Close backpack:  backpack_grid.close_backpack()

Add item:  backpack_grid.get_items(<Dictionary>)

The item dictionary needs to contain the following primary keys: "name", "type", "icon", "number"

For more parameters, please modify them in Parameter_function.gd



使用godot背包插件快速构建背包

你需要修改 backpack_grid/Parameter_function.gd 中的 item_array 数组为你背包的数组

以下是相关的功能方法：

打开背包：backpack_grid.open_backpack()

关闭背包：backpack_grid.close_backpack()

添加物品：backpack_grid.get_items(<Dictionary>)

物品字典需要包含以下主键，"name","type","icon","number"

更多的参数，请在 Parameter_function.gd 中修改
