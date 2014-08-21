package com.editor.module_gdps.proxy
{
	import com.editor.module_gdps.vo.tree.AppLeftTreeItemVO;
	import com.editor.proxy.AppProxy;

	public class GdpsTreeConfigProxy extends AppProxy
	{
		public static const NAME:String = "GdpsTreeConfigProxy";
		
		public function GdpsTreeConfigProxy()
		{
			super(NAME);
		}
		
		public var list:Array = [];
		
		public function parser(a:Array):void
		{
			list = null;
			list = [];
			
			for(var i:int=0;i<a.length;i++)
			{
				list.push(new AppLeftTreeItemVO(a[i]))
			}
			
		}
		
		public function getItemByMenuId(menuId:int):AppLeftTreeItemVO
		{
			for each(var item:AppLeftTreeItemVO in list)
			{
				if(item.id == menuId)
				{
					return item
				}
				if(item.children.length > 0)
				{
					var vo:AppLeftTreeItemVO = getItemByMenuIdFromChildren(item.children, menuId);
					if(vo == null)
					{
						continue;
					}
					else
					{
						return vo;
					}
				}
			}
			return null;
		}
		
		private function getItemByMenuIdFromChildren(children:Array, menuId:int):AppLeftTreeItemVO
		{
			for(var i:int=0; i<children.length; i++)
			{
				var av:AppLeftTreeItemVO = new AppLeftTreeItemVO(children[i]);
				if(av.id == menuId)
				{
					return av;
				}
				if(av.children.length > 0)
				{
					var vo:AppLeftTreeItemVO = getItemByMenuIdFromChildren(av.children, menuId);
					if(vo == null)
					{
						continue;
					}
					else
					{
						return vo;
					}
				}
			}
			return null;
		}
		
		public function createXML():XML
		{
			var x:XML = <i name='菜单'/>
			for each(var item:AppLeftTreeItemVO in list)
			{
				if(item.isRoot === true)
				{
					x.appendChild(item.createXML());
				}
			}
			return x;
		}
	}
}