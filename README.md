# godot - backpacks
Quickly building backpacks with godot

You need to modify the array in  backpack_grid/Parameter_function.gd  item_array to the array in your backpack

The following are the relevant functional methods：

Alt B:  backpack_grid.open_backpack(null)

Close backpack:  backpack_grid.close_backpack()

Add item:  backpack_grid.get_items(<Dictionary>)

The item dictionary needs to contain the following primary keys: "name", "type", "icon", "number"

For more parameters, please modify them in Parameter_function.gd



使用godot背包插件快速构建背包

你需要修改 backpack_grid/Parameter_function.gd 中的 item_array 数组为你背包的数组

以下是相关的功能方法：

打开背包：backpack_grid.open_backpack(null)

关闭背包：backpack_grid.close_backpack()

添加物品：backpack_grid.get_items(<Dictionary>)

物品字典需要包含以下主键，"name","type","icon","number"

更多的参数，请在 Parameter_function.gd 中修改





v1.1  —— 支持指定父节点

https://www.bilibili.com/video/BV1cw411p7Bi/

现在支持传入父节点了，这意味着你不需要再关心如何设置背包的参数了。只需要在打开背包的方法上加上一个父节点。backpack_grid会根据你的父节大小点来控制背包生成的位置和大小，这取决于你每行每列显示的数量。

打开背包：backpack_grid.open_backpack(Parent:control)



Now it supports passing in the parent node, which means you no longer need to worry about how to set the parameters of the backpack. Just add a parent node to the method of opening the backpack. Backpack_grid will control the position and size of the backpack generation based on the size of your parent node, depending on the number of rows and columns displayed.

Alt B:  backpack_grid.open_backpack(Parent:control)
