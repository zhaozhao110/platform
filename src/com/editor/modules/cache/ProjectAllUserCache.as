package com.editor.modules.cache
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.vo.expandComp.ExpandCompItemVO;
	import com.editor.module_ui.vo.expandComp.ExpandCompListVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.math.HashMap;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class ProjectAllUserCache
	{
		private static var instance:ProjectAllUserCache ;
		public static function getInstance():ProjectAllUserCache{
			if(instance == null){
				instance = new ProjectAllUserCache();
			}
			return instance;
		}
		
		private function get cache():ProjectCache
		{
			return ProjectCache.getInstance();
		}
		
		////////////////////////// css ///////////////////////////
		
		private var css_xml_ls:Array; 
		public function getAllCSSXML():void
		{
			if(cache.currEditProjectFile == null) return ;
			var utl:FileUtils = new FileUtils();
			utl.getAllDirectoryListing(new File(cache.getThemePath()+File.separator+"css"),["as"]);
			css_xml_ls = utl.file_ls;
		}
		
		public function findByNameFromCSSXML(nam:String):Array
		{
			if(StringTWLUtil.isWhitespace(nam)) return [];
			if(nam.length < 2) return [];
			if(css_xml_ls == null) return [];
			var a:Array = [];
			for(var i:int=0;i<css_xml_ls.length;i++){
				if(File(css_xml_ls[i]).name.indexOf(nam)!=-1){
					a.push(css_xml_ls[i]);
				}
			}
			return a;
		}
		
		public function findFileByNameFromCSSXML(nam:String):File
		{
			if(StringTWLUtil.isWhitespace(nam)) return null
			if(nam.length < 2) return null
			for(var i:int=0;i<css_xml_ls.length;i++){
				if(File(css_xml_ls[i]).name == ("CSS_"+nam+".as") || File(css_xml_ls[i]).name == (nam+".as")){
					return css_xml_ls[i] as File;
				}
			}
			return null
		}

		public function findASFileByNameFromCSSXML(nam:String):File
		{
			var fl:File = findFileByNameFromCSSXML(nam);
			if(fl!=null&&fl.exists){
				return fl
			}
			return null;
		}
		
		////////////////////// expands ///////////////////////
		
		public function loadExpndComp():void
		{
			expandComp_map.clear();
			var file:File = new File(cache.getExpandCompFold().nativePath+File.separator+"xml");
			if(file.exists){
				var a:Array = file.getDirectoryListing();
				for(var i:int=0;i<a.length;i++){
					_loadExpndComp(a[i] as File);
				}
			}
		}
		
		private function _loadExpndComp(fl:File):void
		{
			if(FileUtils.isSVNFile(fl.name)) return ;
			var nam:String = fl.name;
			var user:String = nam.split("_")[0];
			var read:ReadFile = new ReadFile();
			var xml:XML = XML(read.readCompressByteArray(fl.nativePath));
			var _expandComp:ExpandCompListVO = new ExpandCompListVO(xml);
			addExpandComp(user,_expandComp);
			if(user == AppMainModel.getInstance().user.shortName){
				expandComp = _expandComp;
			}
		}
		
		//自己的xml，自定义组件，可以添加自定义的属性，
		public var expandComp:ExpandCompListVO;
		private var expandComp_map:HashMap = new HashMap();
		
		private function addExpandComp(user:String,d:ExpandCompListVO):void
		{
			expandComp_map.put(user,d);
		}
		
		public function getExpandComp(user:String):ExpandCompListVO
		{
			return expandComp_map.find(user) as ExpandCompListVO;
		}
		
		public function getExpandCompAttri(tp:String):ExpandCompItemVO
		{
			var d:ExpandCompItemVO ;
			d = expandComp.getItem(tp);
			if(d == null){
				for(var user:String in expandComp_map.getContent()) {
					d = ExpandCompListVO(expandComp_map.getContent()[user]).getItem(tp);
					if(d!=null){
						return d;
					}
				}
			}
			return d;
		}
		
		public function reflashExpandComp(a:Array):void
		{
			var file:File = ProjectCache.getInstance().getExpandCompXML();
			var c:String ;
			var write:WriteFile;
			if(!file.exists){
				c = "<!--author by ["+AppMainModel.getInstance().user.shortName+"], please not delete -->"; 
				c += '<?xml version="1.0" encoding="UTF-8"?>';
				c += "<list>";
				for(var i:int=0;i<a.length;i++){
					var xml:XML = XML(a[i]);
					c += xml.toXMLString();
				}
				c += "</list>"
			}else if(expandComp!=null){
				expandComp.reflash(a);
				c = expandComp.createXML();
			}
			write = new WriteFile();
			var be:ByteArray = new ByteArray();
			be.writeUTFBytes(c);
			be.compress();
			write.write(file,be);
		}
		
		
		//////////////////////// swf  /////////////////////////
		
		public function loadCSSLibs(loadComplete_f:Function):void
		{
			var mutltLoadData:ILoadMultSourceData = iManager.iResource.getMultLoadSourceData();
			//iManager.iLogger.info("11");
			if(cache.getBin() == "") return ;
			var file:File = new File(cache.getBin()+File.separator+"theme"+File.separator+"assets"+File.separator+"swf");
			if(file.exists){
				//iManager.iLogger.info("11,"+file.nativePath);
				var a:Array = file.getDirectoryListing();				
				for(var i:int=0;i<a.length;i++){
					var fl:File = a[i] as File;
					if(fl.extension == "swf"){
						var loadData:ILoadSourceData = iManager.iResource.getLoadSourceData();
						loadData.url = fl.nativePath;
						loadData.type = LoadQueueConst.swf_type;
						mutltLoadData.addSWFData(loadData);
						UIEditManager.uiEditor.logCont.addLog("加载:" + fl.nativePath)
					}
				}				
			}
			
			file = new File(cache.getBin()+File.separator+"assets"+File.separator+"swf");
			if(file.exists){//iManager.iLogger.info("22,"+file.nativePath);
				a = file.getDirectoryListing();
				for(i=0;i<a.length;i++){
					fl = a[i] as File;
					if(fl.extension == "swf"){
						loadData = iManager.iResource.getLoadSourceData();
						loadData.url = fl.nativePath;
						loadData.type = LoadQueueConst.swf_type;
						mutltLoadData.addSWFData(loadData);
						UIEditManager.uiEditor.logCont.addLog("加载:" + fl.nativePath)
					}
				}
			}
			//iManager.iLogger.info("22",mutltLoadData.getLoadDataList().length);
			var dt:ILoadQueueDataProxy = iManager.iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = loadComplete_f;
			iManager.iResource.loadMultResource(dt);
		}
		
		
		
		private function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}