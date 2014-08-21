package com.editor.module_sea.vo
{
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.view.SeaMapItemView;
	import com.editor.module_sea.vo.res.SeaMapResInfoItemVO;
	import com.sandy.error.SandyError;
	import com.sandy.math.SandyPoint;
	import com.sandy.utils.ToolUtils;

	public class SeaMapItemVO
	{
		public function SeaMapItemVO(x:XML=null)
		{
			if(x == null) return ;
			id = int(x.@i);
			group = int(x.@g);
			expend = x.@e;
			_container_index = int(x.@ii);
			loc = new SandyPoint(int(x.@x),int(x.@y));	
			resItem = SeaMapModuleProxy.instance.resInfo_ls.getCloneResInfoItemById(id);
			if(resItem == null){
				SandyError.error("没有找到资源"+id);
			}
			
			scaleX = Number(x.@sx);
			if(isNaN(scaleX)) scaleX=1;
			scaleY = Number(x.@sy);
			if(isNaN(scaleY)) scaleY = 1;
		}
		
		private var _container_index:int;
		public var container:SeaMapItemView;
		
		public function get container_index():int
		{
			if(container == null) return _container_index;
			return container.parent.getChildIndex(container);
		}
		
		public var levelItem:SeaMapLevelVO;
		
		public var loc:SandyPoint;
		//资源id
		public var id:int;
		//层次
		public var group:int;
		public var scaleX:Number;
		public var scaleY:Number;
		
		public var resItem:SeaMapResInfoItemVO;
		public var expend:String = "";
		
		public function get name():String
		{
			if(resItem == null) return "";
			return resItem.name;
		}

		public function get name1():String
		{
			return id + "/" + name;
		}
		
		public function get name2():String
		{
			return id + "/" + expend;
		}
		
		public function save():String
		{
			var s:String = '<i '
			s += 'i="'+id+'" '
			s += 'g="'+group+'" '
			s += 'x="'+container.x+'" '
			s += 'y="'+container.y+'" '
			s += 'sx="'+container.scaleX+'" '
			s += 'sy="'+container.scaleY+'" '
			s += 'ii="'+container_index+'" '	
			s += 'e="'+expend+'" />'
			return s;
		}
		
		public function clone():SeaMapItemVO
		{
			var d:SeaMapItemVO = new SeaMapItemVO();
			ToolUtils.clone(this,d);
			return d;
		}
		
		public function remove():void
		{
			container.dispose();
			container = null;
		}
	}
}