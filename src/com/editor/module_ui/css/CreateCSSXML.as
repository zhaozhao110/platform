package com.editor.module_ui.css
{
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class CreateCSSXML
	{
				
		private var write:WriteFile = new WriteFile();
		private var createFile:CreateCSSFile;
		private var data:CSSComponentData;
		
		
		public function create(a:Array,d:CSSComponentData):void
		{
			data = d;
			if(data == null) return ;
			if(data.db == null) return ;
			var c:String = "<!--author by ["+AppMainModel.getInstance().user.shortName+"], please not delete -->"; 
			c += '<?xml version="1.0" encoding="UTF-8"?>';
			c += "<list>";
			c += _createClassInfo();
			
			var data_ls:Array = [];
			for(var i:int=0;i<a.length;i++){
				var ui:IComBase = a[i] as IComBase;
				if(ui!=null){
					var vo:IComBaseVO = ui.getValue();
					if(vo!=null){
						data_ls[vo.key] = vo;
					}
				}
			}
			
			for each(vo in data_ls){
				if(vo!=null&&!StringTWLUtil.isWhitespace(vo.key)&&!StringTWLUtil.isWhitespace(vo.value)){
					//做一些拷贝什么处理，
					vo.createCSSXML(data,data_ls);
					//获取xml
					c += vo.getCSSXML();
				}
			}
			
			c += "</list>";
			_createFile(c);
			
			if(createFile == null){
				createFile = new CreateCSSFile();
			}
			createFile.create(XML(c),d);
		}
		
		private function _createClassInfo():String
		{
			//class name
			var c:String = '<item key="name">';
			c += '<![CDATA[';
			c += data.name;
			c += ']]>'
			c += '</item>'
			
			//class package
			c += '<item key="package">';
			c += '<![CDATA[';
			c += data.db.package_url;
			c += ']]>'
			c += '</item>'
			
			//templete
			c += '<item key="templete">';
			c += '<![CDATA[';
			c += data.type;
			c += ']]>'
			c += '</item>'
				
			//path
			/*c += '<item key="path">';
			c += '<![CDATA[';
			c += ProjectCache.getInstance().getOppositePath(data.file.nativePath)
			c += ']]>'
			c += '</item>'*/
						
			return c;
		}
		
		private function _createFile(c:String):void
		{
			var f:File = new File(data.file.parent.nativePath+File.separator+"xml"+File.separator+data.name+".xml");
			var haveFile:Boolean = f.exists;
			var be:ByteArray = new ByteArray();
			be.writeUTFBytes(c);
			be.compress();
			write.write(f,be);
			
			f = new File(data.file.parent.nativePath+File.separator+"xml");
			UIEditManager.getInstance().writeCmd("attrib +H /D /S "+f.nativePath);
			
			if(!haveFile){
				ProjectAllUserCache.getInstance().getAllCSSXML();
				SandyEngineGlobal.iManager.sendAppNotification(AppModulesEvent.reflashProjectDirect_event);
			}
			
			
		}
		
		
		
		
		
		
		
		
		
	}
}