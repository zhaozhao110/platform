package com.editor.module_avg.vo
{
	import com.editor.module_avg.manager.AVGManager;
	import com.sandy.math.HashMap;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.XMLUtil;
	import com.sandy.utils.interfac.ICloneInterface;

	public class AVGResData implements ICloneInterface
	{
		public function AVGResData(s:String=null,p:String=null)
		{
			if( s == null && p == null) return ;
			fileName = s;
			path = p;
			if(path.substring(path.length-1,path.length)=="/"){
				fullPath = path + fileName;
			}else{
				fullPath = path + "/"+ fileName;
			}
			loadPath = AVGManager.currProject.resFold + "/" + fullPath;
			
			if(id==0)id = resData_total++;
			
			if(isSound){
				putAttri("isCycle",0);
				putAttri("volume",50);
			}
			
			putAttri("name",fileName);
		}
		
		public static var resData_total:int;
		
		public function setXML(x:XML):void
		{
			fileName = x.@name;
			level = x.@ind;
			path = XML(x.child("p1")[0]).text();
			fullPath = XML(x.child("p")[0]).text();
			loadPath = AVGManager.currProject.resFold + "/" + fullPath;
			configData.setContent(XMLUtil.convertXMLToObject(x));	
			
			if(id==0)id = resData_total++;
		}
		
		public var id:int;
		public var loadPath:String;
		public var fullPath:String;
		public var path:String;
		
		private var _level:int;
		public function get level():int
		{
			return _level;
		}
		public function set level(value:int):void
		{
			_level = value;
			if(AVGManager.currFrame!=null){
				AVGManager.currFrame.sortRes();
			}
		}
		
		private var _fileName:String;
		public function get fileName():String
		{
			return _fileName;
		}
		public function set fileName(value:String):void
		{
			_fileName = value;
			if(!StringTWLUtil.isWhitespace(value)){
				suffix = value.split(".")[1];
			}
		}

		public var suffix:String;
		
		public function get directory():Boolean
		{
			return StringTWLUtil.isWhitespace(suffix);
		}
		
		//img,1 , swf,2 . sound ,3
		
		public function get isImage():Boolean
		{
			return suffix == "jpg" || suffix == "png"
		}
		
		public function get isSound():Boolean
		{
			return suffix == "mp3" || suffix == "wav"
		}
		
		public function get isSwf():Boolean
		{
			return suffix == "swf"
		}
		
		public function getResType():int
		{
			if(isImage) return 1;
			if(isSound) return 3;
			if(isSwf) return 2;
			return -1;
		}
		
		public function clone():AVGResData
		{
			var d:AVGResData = new AVGResData();
			ToolUtils.clone(this,d);
			return d;
		}
		
		public var configData:HashMap = new HashMap();
		
		public function putAttri(k:String,v:*):void
		{
			configData.put(k,v);
		}
		
		public function getAttri(k:String):*
		{
			return configData.find(k);
		}
		
		public function existAttri(k:String):Boolean
		{
			return configData.exists(k);
		}
		
		public function getXML():String
		{
			var x:String = "<i ";
			x += 'ind="'+level+'" '
			var elements:Object = configData.getContent();
			var key:String;
			for(key in elements){
				if(key != "ind"){
					x += key+'="'+elements[key]+'" ';
				}
			}
			x += ">"
			x += "<p><![CDATA["+fullPath+']]></p>'
			x += "<p1><![CDATA["+path+']]></p1>'
			x += "</i>"
			return x;
		}
		
		public var opts_cont:String;
		
		private var _condition:String;
		public function get condition():String
		{
			return _condition;
		}
		public function set condition(value:String):void
		{
			_condition = value;
			if(StringTWLUtil.isWhitespace(value)){
				_condition = "";
			}
		}

		public var jumpSectionName:String;
		
		private var _opts_color:uint = ColorUtils.white;
		public function get opts_color():uint
		{
			return _opts_color;
		}
		public function set opts_color(value:uint):void
		{
			_opts_color = value;
			if(StringTWLUtil.isWhitespace(value)){
				_opts_color = ColorUtils.white;
			}
		}
		
		public function get opts_info():String
		{
			return opts_cont + " / 跳转: " + jumpSectionName + " / "+condition ;
		}
		
		public function setOpsXML(x:XML):void
		{
			opts_cont = x.@ct;
			opts_color = x.@co;
			jumpSectionName = x.@j;
			condition = XML(x.child("c")[0]).text();
		}
		
		/**
		 * 
		 * 选项
		 * ct:内容
		 * co:颜色
		 * j:跳转的分段
		 * c:条件
		 * 
		 */ 
		public function getOptXML():String
		{
			var x:String = "<i ";
			x += 'ct="'+opts_cont+'" '
			x += 'co="'+opts_color+'" '
			x += 'j="'+jumpSectionName+'" >'
			x += "<c><![CDATA["+condition+']]></c>'
			x += "</i>"
			return x;
		}
		
		public function cloneObject():*
		{
			var d:AVGResData = new AVGResData();
			ToolUtils.clone(this,d);
			return d;
		}
		
		
	}
}