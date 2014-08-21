package com.editor.module_ui.vo
{
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.sandy.math.TreeNode;
	
	public class UITreeNode extends TreeNode
	{
		public function UITreeNode()
		{
			super();
		}
		
		public function get index():int
		{
			if(obj is UIShowCompProxy){
				return UIShowCompProxy(obj).index;
			}
			return 0;
		}
		
	}
}