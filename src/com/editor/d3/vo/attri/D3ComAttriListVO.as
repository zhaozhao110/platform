package com.editor.d3.vo.attri
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.vo.style.ComStyleItemVO;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.error.SandyError;

	public class D3ComAttriListVO
	{
		public function D3ComAttriListVO(a:Array,_isParticle:Boolean=false)
		{
			isParticle = _isParticle
			parser(a)
		}
		
		public var isParticle:Boolean;
		public var list:Array = [];
		
		private var map:Array = [];
		private var mapId:Array = [];
		
		private function parser(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var item:D3ComAttriItemVO = new D3ComAttriItemVO(a[i]);
				list.push(item);
				if(map[item.key] != null){
					SandyError.error("have value at:" + item.key);
				}
				map[item.key] = item;
				mapId[item.id.toString()] = item;
			}
			
			list = list.sortOn("key");
			
			if(!isParticle){
				var d3CompToReflashAttri_ls:Array = [];
				for(i=0;i<list.length;i++){
					item = list[i];
					if(item.getExpand2(0) == "1"){
						d3CompToReflashAttri_ls.push(item);
					}
				}
				D3ComponentConst.d3CompToReflashAttri_ls = d3CompToReflashAttri_ls;
			}
		}
		
		public function getItemByKey(key:String):D3ComAttriItemVO
		{
			return map[key] as D3ComAttriItemVO;
		}
		
		public function getItemById(key:String):D3ComAttriItemVO
		{
			return mapId[key] as D3ComAttriItemVO;
		}
		
		public function getArray(a:Array):Array
		{
			var out:Array = [];
			for(var j:int=0;j<a.length;j++){
				if(int(a[j])>0){
					out.push(D3ComAttriItemVO(mapId[String(a[j])]))
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
				if(D3ComAttriItemVO(a[j]).key == key){
					return true
				}
			}
			return false;
		}
		
		public function getGroup(g:int):Array
		{
			var out:Array = [];
			for(var j:int=0;j<list.length;j++){
				if(D3ComAttriItemVO(list[j]).type == g.toString()){
					out.push(D3ComAttriItemVO(list[j]))
				}
			}
			return out;
		}
		
	}
}