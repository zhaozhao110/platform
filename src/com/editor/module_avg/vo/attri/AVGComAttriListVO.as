package com.editor.module_avg.vo.attri
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.vo.style.ComStyleItemVO;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.error.SandyError;

	public class AVGComAttriListVO
	{
		public function AVGComAttriListVO(a:Array)
		{
			parser(a)
		}
		
		public var list:Array = [];
		
		private var map:Array = [];
		private var mapId:Array = [];
		
		private function parser(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var item:AVGComAttriItemVO = new AVGComAttriItemVO(a[i]);
				list.push(item);
				if(map[item.key] != null){
					SandyError.error("have value at:" + item.key);
				}
				map[item.key] = item;
				mapId[item.id.toString()] = item;
			}
			list = list.sortOn("key");
		}
		
		public function getItem(key:String):AVGComAttriItemVO
		{
			return mapId[key] as AVGComAttriItemVO
		}
		
		public function getArray(a:Array):Array
		{
			var out:Array = [];
			for(var j:int=0;j<a.length;j++){
				if(int(a[j])>0){
					out.push(AVGComAttriItemVO(mapId[String(a[j])]))
				}
			}
			return out;
		}
		
		public function getItemById(d:int):AVGComAttriItemVO
		{
			return mapId[d.toString()] as AVGComAttriItemVO;
		}
		
	}
}