package com.editor.module_ui.vo
{
	import com.asparser.ClsDB;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.air.io.ReadFile;
	import com.editor.module_ui.css.PaserCSSXML;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	

	public class CSSComponentData
	{
		public function CSSComponentData()
		{
		}
		
		//组件的名字: Button ,Canvas
		public var type:String;
		//类名
		public var name:String;
		public var icon:String;
		//类的内容
		public var info:String;
		public var item:ComItemVO;
		//E:/hg_res/sandy_engine/test/uiTest/src/theme/css/CSS_btn2.as
		public var file:File;
		public var db:ClsDB;
		public var paser:PaserCSSXML;
		public var parserComplete:Function;
		
		public function parserFile(fl:File):void
		{
			file = fl;
			
			var read:ReadFile = new ReadFile();
			info = read.read(fl.nativePath);
			
			getCSSTemple();
			Parser.addSourceFile(info,file.nativePath,_parserComplete);
		}
		
		public function parserFileContent(f:String):void
		{
			info = f;
			getCSSTemple();
			Parser.addSourceFile(info,file.nativePath,_parserComplete);
		}
		
		private function getCSSTemple():void
		{
			var a:Array = StringTWLUtil.splitNewline(info);
			var _firstStr:String = a[0];
			if(_firstStr.indexOf(">")!=-1){
				type = StringTWLUtil.getContent(_firstStr,"<",">")[0];
			}
			paser = new PaserCSSXML(this);
		}
		
		private function _parserComplete():void
		{
			db = new ClsDB(TypeDBCache.getDB(file.nativePath));
			name = db.name;
			if(parserComplete!=null) parserComplete(this);
			parserComplete = null;
		}
		
	}
}