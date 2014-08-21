package com.editor.module_avg.vo.comp
{
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;

	public class AVGCompItemVO
	{
		public function AVGCompItemVO(obj:*=null)
		{
			if(obj == null) return 
			id = int(obj.id);
			name = obj.name;
			group = int(obj.group_id);
			type = group;
			attri = obj.attri;
			group2 = int(obj.group2);
			en = obj.en;
			
			if(id != 3){
				if(StringTWLUtil.isWhitespace(attri)){
					attri = default_attri_ls.join(",");
				}else{
					var a:Array = attri.split(",");
					var b:Array = default_attri_ls;
					for(var i:int=0;i<b.length;i++){
						var def_id:String = b[i] ;
						if(a.indexOf(def_id)==-1){
							a.push(def_id);
						}
					}
					attri = a.join(",");
				}
			}
		}
		
		public static const default_attri_ls:Array = [1,2,3,4,5,6,7,8,9,10,11,12,16,17];
		
		//英文名
		public var en:String;
		public var id:int;
		public var name:String;
		public var type:int;
		public var group:int;
		//outline窗口里的还是project窗口里的
		public var group2:int;
		public var attri:String;
		public var data:*;
		
		public function clone():AVGCompItemVO
		{
			var d:AVGCompItemVO = new AVGCompItemVO();
			ToolUtils.clone(this,d);
			return d;
		}
		
	}
}