package com.editor.module_ui.vo.attri
{
	import com.editor.manager.DataManager;
	import com.editor.module_ui.vo.style.ComStyleItemVO;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.error.SandyError;

	public class ComAttriListVO
	{
		public function ComAttriListVO(a:Array)
		{
			parser(a)
		}
		
		public var list:Array = [];
		
		private var map:Array = [];
		private var mapId:Array = [];
		
		private function parser(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var item:ComAttriItemVO = new ComAttriItemVO(a[i]);
				list.push(item);
				if(map[item.key] != null){
					SandyError.error("have value at:" + item.key);
				}
				map[item.key] = item;
				mapId[item.id.toString()] = item;
			}
			list = list.sortOn("key");
		}
		
		public function getItem(key:String):ComAttriItemVO
		{
			return map[key] as ComAttriItemVO
		}
		
		public function getArray(a:Array):Array
		{
			var out:Array = [];
			for(var j:int=0;j<a.length;j++){
				if(int(a[j])>0){
					out.push(ComAttriItemVO(mapId[String(a[j])]))
				}
			}
			return out;
		}
		
		public function getDefaultArray():Array
		{
			return getArray(DataManager.default_attri_ls);
		}
		
		public function checkIsDefaultAttri(key:String):Boolean
		{
			var a:Array = getDefaultArray();
			for(var j:int=0;j<a.length;j++){
				if(ComAttriItemVO(a[j]).key == key){
					return true
				}
			}
			return false;
		}
		
		
	}
}