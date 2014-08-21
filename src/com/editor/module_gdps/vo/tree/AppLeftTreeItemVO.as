package com.editor.module_gdps.vo.tree
{
	public class AppLeftTreeItemVO
	{
		public function AppLeftTreeItemVO(obj:Object)
		{
			parser(obj)
		}
		
		
		public var itemObj:Object;
		public var id:Number;
		public var name:String;
		public var parentId:Number;
		public var children:Array = [];
		
		/**
		 * 是否是根节点
		 * @default 
		 */
		public var isRoot:Boolean = false;
		
		private function parser(obj:Object):void
		{
			itemObj = obj;
			id = obj.id;
			name = obj.name;
			parentId = obj.pid
			isRoot = (obj.pid == null ? true : false);
			children = obj.children;
		}
		
		public function createXML():XML
		{
			var x:XML = <i id="" name="" pid="1" />
			x.@id = id;
			x.@name = name;
			x.@pid = parentId;
			if(children != null && children.length > 0)
			{
				findChild(children, x);
			}
			return x;
		}
		
		private function findChild(children:Array, cx:XML):XML
		{
			if(children != null && children.length > 0)
			{
				for(var i:int=0; i<children.length; i++)
				{
					var treeVO:AppLeftTreeItemVO = new AppLeftTreeItemVO(children[i]);
					cx.appendChild(treeVO.createXML());
				}
			}
			return cx;
		}
		
	}
}