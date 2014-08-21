package com.editor.module_sea.vo
{
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.view.SeaMapItemView;
	import com.editor.module_sea.view.SeaMapLevelView;
	import com.sandy.error.SandyError;

	public class SeaMapLevelVO
	{
		public function SeaMapLevelVO(x:XML=null)
		{
			if(x == null) return ;
			index = int(x.@i);
			name = x.@n;
			_container_index = int(x.@ii);
		}
		
		public var index:int=-1;
		public var name:String;
		public var container:SeaMapLevelView;
		private var _container_index:int;
		
		public function get container_index():int
		{
			if(container == null) return _container_index;
			return container.parent.getChildIndex(container);
		}
		
		public function save():String
		{
			return '<i i="'+index+'" n="'+name+'" ii="'+container_index+'" />'
		}
		
		public var item_ls:Array = [];
		
		public function addItem(d:SeaMapItemVO):void
		{
			d.levelItem = this;
			item_ls.push(d);
			item_ls = item_ls.sortOn("container_index",Array.NUMERIC);
		}
		
		public function getArrayByRedId(g:int):Array
		{
			var a:Array = [];
			for(var i:int=0;i<item_ls.length;i++){
				if(SeaMapItemVO(item_ls[i]).resItem.id == g){
					a.push(item_ls[i]);
				}
			}
			return a;
		}
		
		public function revemoItem(d:SeaMapItemVO):void
		{
			var n:int = item_ls.indexOf(d);
			if(n >= 0){
				d.remove();
				item_ls.splice(n,1);
			}
		}
		
		public function createItem(d:SeaMapItemVO):SeaMapItemView
		{
			d.resItem = SeaMapModuleProxy.instance.resInfo_ls.getCloneResInfoItemById(d.id);
			if(d.resItem == null){
				SandyError.error("没有找到资源"+d.id);
				return null;
			}
			d.group = index;
			SeaMapModuleManager.mapData.createItem(d);
			return container._createItem(d,false);
		}
		
		public function removeItems():void
		{
			for(var i:int=0;i<item_ls.length;i++){
				SeaMapItemVO(item_ls[i]).remove();
			}
			item_ls = null;
		}
		
		public function saveItems():String
		{
			var s:String = "";
			for(var i:int=0;i<item_ls.length;i++){
				s += SeaMapItemVO(item_ls[i]).save();
			}
			return s;
		}
	}
}