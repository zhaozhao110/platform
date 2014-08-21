package com.editor.module_ui.view.uiAttri.vo
{
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.css.CreateCSSFileItemVO;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ComFileVO extends ComBaseVO
	{
		public function ComFileVO()
		{
			super();
		}
		
		public var scaleGridTop:int;
		public var scaleGridRight:int;
		public var scaleGridBottom:int;
		public var scaleGridLeft:int;
		
		public function checkValue():Boolean
		{
			if(scaleGridTop>0&&scaleGridRight>0&&scaleGridBottom>0&&scaleGridLeft>0){
				return true;
			}
			return false;
		}
		
		override public function getCSSXML():String
		{
			var c:String = '<item key="'+key+'" '
			c += ' type="'+target.item.type+'" ';
			if(checkValue()){
				c += 'scaleGridTop="'+scaleGridTop+'" '
				c += 'scaleGridRight="'+scaleGridRight+'" '
				c += 'scaleGridBottom="'+scaleGridBottom+'" '
				c += 'scaleGridLeft="'+scaleGridLeft+'" >'
			}else{
				c += ">";
			}
			c += '<![CDATA[';
			c += value;
			c += ']]>'
			c += '</item>'
			return c;
		}
		
		override public function getCSSFile():String
		{
			var src:String = "/src/";
			var s:String = createSpace(2);
			s += '[Embed(source="';
			if(String(value).indexOf(src)!=-1){
				s += String(value).substr(src.length)+'"';
			}else{
				s += String(value)+'"';
			}
			if(s.indexOf(File.separator)!=-1){
				s = s.split(File.separator).join("/");
			}
			if(scaleGridTop>0&&scaleGridBottom>0&&scaleGridLeft>0&&scaleGridRight>0){
				s += ',scaleGridTop="'+scaleGridTop+'",scaleGridBottom="'+scaleGridBottom+'",scaleGridLeft="'+scaleGridLeft+'",scaleGridRight="'+scaleGridRight+'")]';
			}else{
				s += ')]'
			}
			s += NEWLINE_SIGN;
			s += createSpace(2)+"public"+" "+"var"+" "+key+":Class;"+NEWLINE_SIGN;
			return s;
		}
		
		private function checkIsSkin():Boolean
		{
			if(CreateCSSFileItemVO.checkIsSkin(key)){
				return true;
			}
			return false;
		}
		
		private function get file():File
		{
			var url:String = value.toString();
			if(url.indexOf(":")!=-1){
				return new File(value);
			}
			return new File(ProjectCache.getInstance().getProjectOppositePath(value));
		}
		
		override public function createCSSXML(d:CSSComponentData,a:Array):void
		{
			if(checkIsSkin()){
				//把主题图片拷贝到项目中，并且把路径改成项目中的路径
				if(IComBaseVO(a["embedType"])!=null){
					var embedType:int = int(IComBaseVO(a["embedType"]).value);
					var path:String;
					if(embedType ==0){
						//trace(file.nativePath);
						//var path:String;
						if(AppGlobalConfig.instance.user_vo.getUser2(file.parent.name)!=null){
							path = AppMainModel.getInstance().user.getCSSAssetsFold(file.parent.name).nativePath;
						}else{
							path = AppMainModel.getInstance().user.getCSSAssetsFold().nativePath;
						}
						var _fl:File = new File(path);
						if(!_fl.exists){
							_fl.createDirectory();
						}
						var newFile:File = new File(path+File.separator+file.name);
						if(!newFile.exists){
							WriteFile.copy(file,newFile);
						}
						value = ProjectCache.getInstance().getOppositePath(newFile.nativePath);
						
					}else if(embedType == 1){
						
						if(AppGlobalConfig.instance.user_vo.getUser2(file.parent.name)!=null){
							path = AppMainModel.getInstance().user.getAssetsImgFold(file.parent.name).nativePath;
						}else{
							path = AppMainModel.getInstance().user.getAssetsImgFold().nativePath;
						}
						_fl = new File(path);
						if(!_fl.exists){
							_fl.createDirectory();
						}
						newFile = new File(path+File.separator+file.name);
						if(!newFile.exists){
							WriteFile.copy(file,newFile);
						}
						value = ProjectCache.getInstance().getOppositePath(newFile.nativePath);
					}
				}
				
			}
		}
		
		
		
	}
}