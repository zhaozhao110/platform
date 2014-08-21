package com.editor.module_ui.ui.vo
{
	import com.editor.manager.DataManager;
	import com.editor.module_ui.vo.UICreateData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.asComponent.containers.ASHBox;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.group.ASBoxGroup;
	import com.sandy.asComponent.group.IASBoxGroup;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class InvertedGroupVO
	{
		public function InvertedGroupVO()
		{
		}
		
		public var id:String;
		
		public function get direction():String
		{
			return boxGroup.direction;
		}
		
		public function get name():String
		{
			return boxGroup.COMPONENT_NAME;
		}
		
		public var boxGroup:IASBoxGroup;
		
		public function createGroup(direction:String="empty"):void
		{
			if(boxGroup==null){
				boxGroup = new ASBoxGroup();
			}
			boxGroup.direction = direction;
		}
		
		public function createGroupFromXML(d:CreateUIFileCompAttri):void
		{
			if(boxGroup==null){
				boxGroup = new ASBoxGroup();
			}
			id = d.attri_ls["id"]
			for(var key:String in d.attri_ls){
				if(key!="groupId" && key != "type" && key != "parent" && key != "id"){
					boxGroup[key] = d.attri_ls[key]; 
				}
			}
		}
				
		public function getXML():String
		{			
			if(boxGroup.numChildren == 0) return "";
			var out:String = "<item ";
			
			var attriObj:Array = getAttri();
			var key:String;
			for(key in attriObj){
				if(!StringTWLUtil.isWhitespace(key)){
					out += " " + key+'="'+attriObj[key]+'" ';
				}
			}
			
			out += " />"
			return out;
		}
		
		public function getAttri():Array
		{
			var a:Array = [];
			a["id"] = id;
			a["groupId"] = DataManager.comType_5
			a["type"] = "BoxGroup";
			a["direction"] = boxGroup.direction;
			if(!isNaN(boxGroup.x)){
				a["x"] = boxGroup.x;
			}
			if(!isNaN(boxGroup.y)){
				a["y"] = boxGroup.y;
			}
			if(!isNaN(boxGroup.width)){
				a["width"] = boxGroup.width;
			}
			if(!isNaN(boxGroup.height)){
				a["height"] = boxGroup.height;
			}
			if(!StringTWLUtil.isWhitespace(boxGroup.verticalAlign)){
				a["verticalAlign"] = boxGroup.verticalAlign;
			}
			if(!StringTWLUtil.isWhitespace(boxGroup.horizontalAlign)){
				a["horizontalAlign"] = boxGroup.horizontalAlign;
			}
			if(!isNaN(boxGroup.verticalGap)){
				a["verticalGap"] = boxGroup.verticalGap;
			}
			if(!isNaN(boxGroup.horizontalGap)){
				a["horizontalGap"] = boxGroup.horizontalGap;
			}
			a["visible"] = boxGroup.visible;
			return a;
		}
		
		public function getAS(cont:String):UICreateData
		{
			if(boxGroup.numChildren == 0) return null;
			var d:UICreateData = new UICreateData();
			d.vars += "public"+" "+"var"+" "+id+":"+"UIBoxGroup"+";"+NEWLINE_SIGN;
			d.addImport("com.rpg.component.group.*;");
			
			var out:String = createSpace(3)+id+" = new " +"UIBoxGroup();"+NEWLINE_SIGN;
			var attriObj:Array = getAttri();
			var key:String;
			for(key in attriObj){
				if(!StringTWLUtil.isWhitespace(key) && noSaveKeys(key)){
					out += createSpace(3)+id+"."+key+' = '+parserValueInAS(attriObj[key],key)+';'+NEWLINE_SIGN;
				}
			}
			
			out += NEWLINE_SIGN;
			d.comp = out;
			return d;
		}
		
		private function parserValueInAS(v:*,key:String):*
		{
			var val:String = v;
			var key_item:ComAttriItemVO;
			key_item = AppComponentProxy.instance.attri_ls.getItem(key);
			if(key_item!=null && key_item.dataType == "string"){
				val = '"'+val+'"';
			}
			if(key == "source"){
				val = val.split(File.separator).join("/");
			}
			if(key == "color"){
				val = "0x"+uint(val).toString(16);
			}
			if(v is Array){
				val = "["+(v as Array).join(",")+"]";
			}
			return val;
		}
		
		private function noSaveKeys(ky:String):Boolean
		{
			if(ky == "type") return false;
			if(ky == "groupId") return false;
			return true;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
		public function dispose():void
		{
			if(boxGroup == null) return ;
			var n:int = boxGroup.numChildren;
			for(var i:int=0;i<boxGroup.numChildren;i++){
				ASComponent(boxGroup.getChildAt(i)).inventedGroup = null;
			}
		}
		
		
	}
}