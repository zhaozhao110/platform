package com.editor.module_ui.vo.component
{
	import com.sandy.error.SandyError;

	public class ComListVO
	{
		public function ComListVO(a:Array)
		{
			parser(a)
		}
		
		public var list:Array = [];
		public var all_ls:Array = [];
		
		//虚拟面板
		public static var comType4_ls:Array = [];
		
		private function parser(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var item:ComItemVO = new ComItemVO(a[i]);
				var g:ComGroupVO;
				if(getGroup(item.groupId)==null){
					g = new ComGroupVO();
					g.id = item.groupId;
					g.parser();
					list[g.id.toString()] = g;
				}else{
					g = getGroup(item.groupId);
				}
				g.addItem(item);
				if(all_ls[item.name] != null){
					SandyError.error("have same value in compent at:" + item.name);
				}
				all_ls[item.name] = item;
				if(item.groupId == 4){
					comType4_ls.push(item);
				}
			}
			comType4_ls = comType4_ls.sortOn("id",Array.NUMERIC)
		}
		
		public function getAllGroup():Array
		{
			var out:Array = [];
			for each(var item:ComGroupVO in list){
				if(item!=null){
					out.push(item);
				}
			}
			return out.sortOn("id",Array.NUMERIC);
		}
		
		public function getGroup(groupId:int):ComGroupVO
		{
			return list[groupId.toString()] as ComGroupVO
		}
		
		public function getItemByName(nm:String):ComItemVO
		{
			return all_ls[nm] as ComItemVO
		}
		
		public function getListHaveStyle():Array
		{
			var out:Array = [];
			for each(var item:ComItemVO in all_ls){
				if(item.haveStyle){
					out.push(item);
				}
			}
			return out.sortOn("id",Array.NUMERIC);
		}
	}
}