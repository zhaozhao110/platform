package com.editor.module_ui.ui.vo
{
	import com.editor.module_ui.css.CreateCSSFileItemVO;
	import com.editor.module_ui.ui.CreateUIFile;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.UICreateData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.net.json.SandyJSON;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.XMLToJson;

	public class CreateUIFileCompAttri
	{
		public function CreateUIFileCompAttri(x:XML=null)
		{
			if(x == null) return 
			var p:XMLToJson = new XMLToJson();
			var obj:Object = p.parse(x);
						
			for(var key:String in obj){
				if(noSaveAttri(key)){
					attri_ls[key] = parserValue(String(obj[key]),key);
					if(key == "styleName"){
						CreateUIFile.parserStyleName(ProjectAllUserCache.getInstance().findByNameFromCSSXML("CSS_"+attri_ls[key])[0]);
					}
				}
			}
		}
				
		public static const tabNav_url:String = "viewsURL"
		public static const tabNav_label:String = "viewsName";
		
		private function noSaveAttri(key:String):Boolean
		{
			if(key == "_content") return false;
			return true;
		}
		
		private function parserValue(v:*,key:String):*
		{
			var t:ComAttriItemVO = UIEditManager.currEditShowContainer.get_AppComponentProxy().attri_ls.getItem(key)
			if(String(v).indexOf(".jpg")!=-1||
				String(v).indexOf(".png")!=-1||
				String(v).indexOf(".swf")!=-1||
				String(v).indexOf(".xml")!=-1||
				String(v).indexOf(".txt")!=-1){
				return ProjectCache.getInstance().getProjectOppositePath(v); 
			}
			if(t!=null){
				/*if(CreateCSSFileItemVO.isFilters(key)){
					return CreateCSSFileItemVO.convertToFilterArray(String(v).split(";"));
				}*/
				if(t.value == "array"){
					return String(v).split(";");	
				}
			}
			return v;
		}
		
		public var compData:ComponentData;
		public var attri_ls:Array = [];
		
		public function get index():int
		{
			return int(attri_ls["index"]);
		}
		
		public function checkIsProxyComp():Boolean
		{
			return type == "ProxyComp"
		}
		
		public function setAttri(key:String,v:*):void
		{
			attri_ls[key] = v;
		}
		
		public function get type():String
		{
			return attri_ls["type"];
		}
		
		public function get id():String
		{
			return attri_ls["id"];
		}
		
		public function get groupId():int
		{
			return int(attri_ls["groupId"]);
		}
		
		public function get parent():String
		{
			if(StringTWLUtil.isWhitespace(attri_ls["parent"])) return "stage";
			return attri_ls["parent"];
		}
		
		public function getAS(cont:String):String
		{
			var d:UICreateData = compData.getAS(cont,true);
			return d.comp;
		}
		
		
	}
}