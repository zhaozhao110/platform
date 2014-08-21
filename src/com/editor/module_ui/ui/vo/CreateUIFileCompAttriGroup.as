package com.editor.module_ui.ui.vo
{
	import com.editor.manager.DataManager;
	import com.editor.module_ui.ui.CreateUIXML;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.module_ui.vo.expandComp.ExpandCompItemVO;
	import com.editor.module_ui.vo.expandComp.ExpandCompListVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.utils.StringTWLUtil;

	public class CreateUIFileCompAttriGroup
	{
		public function CreateUIFileCompAttriGroup()
		{
			
		}
		
		
		
		public function get id():String
		{
			if(isStage) return "";
			return comp.id;
		}
		public function get index():int
		{
			if(isStage) return -1;
			return comp.index;
		}
		public function get type():String
		{
			if(isStage) return "";
			return comp.type;
		}
		public function get target():CreateUIFileCompAttri
		{
			return comp;
		}
		
		public var isStage:Boolean;
		public var comp:CreateUIFileCompAttri;
		public var child_ls:Array = [];
		
		public function addItem(c:CreateUIFileCompAttri):void
		{
			if(isStage){
				c.attri_ls["parent"] = "stage";
			}
			child_ls.push(c);
			child_ls = child_ls.sortOn("index",Array.NUMERIC);
		}
		
		public function setTarget(cp:CreateUIFileCompAttri):void
		{
			comp = cp;
		}
		
		public function createChildren():void
		{
			_createChildren(comp);
			
			for(var i:int=0;i<child_ls.length;i++)
			{
				var d:CreateUIFileCompAttri = child_ls[i] as CreateUIFileCompAttri;
				if(d.groupId == DataManager.comType_5)
				{
					if(!UIEditManager.currEditShowContainer.cache.getInvertedGroup(d.groupId.toString())){
						var g:InvertedGroupVO = new InvertedGroupVO();
						g.createGroupFromXML(d)
						UIEditManager.currEditShowContainer.cache.addInvertedGroup(g);
					}
				}
			}
			
			for(i=0;i<child_ls.length;i++)
			{
				d = child_ls[i] as CreateUIFileCompAttri;
				_createChildren(d);
			}
		}
		
		private function _createChildren(d:CreateUIFileCompAttri):void
		{
			if(d == null) return 
			
			if(UIEditManager.currEditShowContainer.cache.findCompById(d.id)) return ;
				
			if(d.groupId == DataManager.comType_6 && !d.checkIsProxyComp())
			{
				var obj:ComponentData = new ComponentData();
				obj.name = d.type;
				obj.icon = "Canvas_a";
				obj.compAttriItem = d;
				obj.attriObj = d.attri_ls;
				
				var dd:ComItemVO = new ComItemVO();
				dd.name = obj.name;
				dd.groupId = d.groupId;
				dd.attriList = AppComponentProxy.instance.attri_ls.getDefaultArray()
				
				var a:Array = [];
				var expnadComp:ExpandCompItemVO = ProjectAllUserCache.getInstance().getExpandCompAttri(d.type)
				if(expnadComp!=null){
					a = expnadComp.attri_ls; 
					for(var key:String in a){
						if(!StringTWLUtil.isWhitespace(key) && key != "groupId"){
							var at:ComAttriItemVO = new ComAttriItemVO();
							at.key= key;
							var obj1:Object = a[key];
							if(obj1!=null){
								at.dataType = obj1.dataType;
								at.value = obj1.value;
								dd.addAttri(at);
							}
						}
					}
				}
				
				obj.item = dd;
				UIEditManager.currEditShowContainer.addComp(obj,true);
			}
			else if(d.groupId != DataManager.comType_5)
			{
				dd = UIEditManager.currEditShowContainer.get_AppComponentProxy().com_ls.getItemByName(d.type);
				obj = new ComponentData();
				obj.name = dd.name;
				obj.icon = dd.name+"_a";
				obj.item = dd;
				obj.compAttriItem = d;
				obj.attriObj = d.attri_ls;
				UIEditManager.currEditShowContainer.addComp(obj,true);
			}
		}
									
		public function getAS(cont:String,getStage:Boolean=false):String
		{
			var out:String = NEWLINE_SIGN;
			if(getStage){
				if(comp == null) return "";
				if(CreateUIXML.cacheGetAS_ls.indexOf(id)==-1){
					out += comp.getAS(cont);	
				}
				out += NEWLINE_SIGN;
				return out;
			}
			for(var i:int=0;i<child_ls.length;i++){
				var d:CreateUIFileCompAttri = child_ls[i] as CreateUIFileCompAttri;
				if(CreateUIXML.cacheGetAS_ls.indexOf(d.id)==-1){
					out += d.getAS(cont);	
				}
			}
			out += NEWLINE_SIGN;
			return out;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
	}
}