package com.editor.module_ui.vo.style
{
	import com.sandy.error.SandyError;

	public class ComStyleListVO
	{
		public function ComStyleListVO(a:Array)
		{
			parser(a)
		}
		
		public var list:Array = [];
		
		private var map:Array = [];
		private var mapId:Array = [];
		
		private function parser(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var item:ComStyleItemVO = new ComStyleItemVO(a[i]);
				list.push(item);
				if(map[item.key] != null){
					SandyError.error("have value at:" + item.key);
				}
				map[item.key] = item;
				mapId[item.id.toString()] = item
			}
		}
		
		public function getItem(key:String):ComStyleItemVO
		{
			return map[key] as ComStyleItemVO
		}
		
		public function getArray2(a:Array):Array
		{
			var out:Array = [];
			for(var j:int=0;j<a.length;j++){
				if(int(a[j])>0){
					out.push(mapId[String(a[j])])
				}
			}
			return out;
		}
		
		public function getListBySameValue(val:String):Array
		{
			var out:Array = [];
			for(var j:int=0;j<list.length;j++){
				if(ComStyleItemVO(list[j]).value == val){
					out.push(list[j]);
				}
			}
			return out;
		}
		
	}
}