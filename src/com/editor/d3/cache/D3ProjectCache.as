package com.editor.d3.cache
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.air.thread.ThreadMessageData;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.app.view.ui.right.App3DRightContainerMediator;
	import com.editor.d3.app.view.ui.top.App3DTopBarContainerMediator;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.tool.D3ReadFile;
	import com.editor.d3.tool.D3WriteFile;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.d3.view.particle.behaviors.ParticleAttri_beh;
	import com.editor.d3.view.particle.behaviors.ParticleBehCache;
	import com.editor.d3.vo.project.D3ProjectVO;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.utils.ByteArrayUtil;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class D3ProjectCache
	{
		private static var instance:D3ProjectCache ;
		public static function getInstance():D3ProjectCache{
			if(instance == null){
				instance =  new D3ProjectCache();
			}
			return instance;
		}
		
		public static var disabledDataChange:Boolean = true;
		
		
		private static var _dataChange:Boolean;
		public static function get dataChange():Boolean
		{
			return _dataChange;
		}
		public static function set dataChange(value:Boolean):void
		{
			if(dataChange == value) return ;
			if(disabledDataChange) return ;
			if(D3ProjectFilesCache.getInstance().getProjectFold() == null) return ;
			_dataChange = value;
			get_App3DTopBarContainerMediator().reflashSaveInfo();
			if(value){
				trace("dataChange is true");
			}
		}
				
		public static var saveTime:String;
		private static var saveTime_n:Number;
		
		//outline里的全部保存,project里的立即保存的
		public function createXML(path:String = ""):void
		{
			if(D3SceneCache.instance.currSceneFile == null) return ;
			if(!isNaN(saveTime_n)){
				if((getTimer()-saveTime_n)<100) return ;
			}
			
			var x:Object = {};
			
			//name
			var f:String ;
			if(StringTWLUtil.isWhitespace(path)){
				f = D3SceneCache.instance.currSceneFile.nativePath;
			}else{
				f = path;
			}
			if(StringTWLUtil.isWhitespace(f)){
				get_App3DMainUIContainerMediator().hideLoading();
				dataChange = false;
				return ;
			}
			
			var project:File = new File(f);
			
			var d:D3DisplayListCache = D3SceneManager.getInstance().displayList;
			x.comps = d.rootNode.objectSave();
			x.global = d.rootNode.getGlobalSave();
			
			var xs:String = JSON.stringify(x);

			var w:D3WriteFile = new D3WriteFile();
			w.write(project,xs);
			
			saveTime_n = getTimer();
			saveTime = TimerUtils.getCurrentTime_str();
			
			D3ResChangeProxy.getInstance().changeContent(project.nativePath,xs);
			dataChange = false;
			get_App3DTopBarContainerMediator().reflashSaveInfo();
		}
		
		//Change3DProjectInterceptor
		public function readConfig():void
		{
			var xs:String = readXML();
			D3ProjectVO.instance.parse(xs);
			
			var dafScene:String = D3ProjectVO.instance.getAttri("defaultScene");
			iManager.sendAppNotification(D3Event.change3DScene_event,dafScene);
		}
		
		public function changeScene(dafScene:String):void
		{
			D3SceneCache.instance.currSceneFile = D3SceneCache.instance.getSceneFile(dafScene);
			var xs:String = D3SceneCache.instance.getSceneFileCont(dafScene);
			if(!StringTWLUtil.isWhitespace(xs)){
				var x:Object = JSON.parse(xs);
				D3ResChangeProxy.getInstance().addFile(D3SceneCache.instance.currSceneFile,x);	
			}else{
				D3ResChangeProxy.getInstance().addFile(D3SceneCache.instance.currSceneFile,"");
			}
			
			BackgroundThreadCommand.instance.parser3DProject(D3ProjectFilesCache.getInstance().getProjectFold());
			get_App3DMainUIContainerMediator().showLoading();
		}
				
		public function afterParserProject():void
		{
			if(D3SceneManager.getInstance().currScene.sceneContianer == null){
				setTimeout(afterParserProject,1000);
			}else{
				later_afterParserProject()
			}
		}
		
		private function later_afterParserProject():void
		{
			trace("--afterParserProject -- ")
			var x:Object = D3ResChangeProxy.getInstance().getFile(D3SceneCache.instance.currSceneFile.nativePath).content;

			if(!StringTWLUtil.isWhitespace(x)){
				obj = x.comps;
				if(obj!=null){
					D3SceneManager.getInstance().displayList.convertObjectXML(obj);
				}
				var obj:Object = x.global;
				if(obj!=null){
					D3SceneManager.getInstance().displayList.convertObjectXML(obj,null,true);
				}
			}
			D3SceneManager.getInstance().displayList.checkGlobalIsInited();
			
			get_App3DMainUIContainerMediator().hideLoading();
			D3SceneManager.getInstance().currScene.onViewToStage();
			dataChange = false;
			get_D3OutlinePopViewMediator().respondToChange3DProjectEvent();
		}
		
		public function openConfigByIE():void
		{
			if(D3ProjectFilesCache.getInstance().getConfigFile() == null) return ;
			if(!D3ProjectFilesCache.getInstance().getConfigFile().exists) return ;
			var f:File = new File(File.desktopDirectory.nativePath+File.separator+"d3ProCache.json");
			var r:D3WriteFile = new D3WriteFile();
			var obj:* = D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().getConfigFile().nativePath).content;
			if(obj is String){
				r.write(f,obj);
			}else{
				r.write(f,JSON.stringify(obj));
			}
			//f.openWithDefaultApplication();
		}
		
		private function readXML():String
		{
			var file:File = D3ProjectFilesCache.getInstance().getConfigFile();
			var r:D3ReadFile = new D3ReadFile();
			return r.read(file.nativePath)
		}
		
		
		
		
		
		/////////////////////////// particle ///////////////////////////
		private var saveTime_n2:Number;
		
		public function saveParticle():void
		{
			if(!isNaN(saveTime_n2)){
				if((getTimer()-saveTime_n2)<100) return ;
			}
			
			if(D3SceneManager.getInstance().displayList.selectedParticle!=null){
				if(D3SceneManager.getInstance().displayList.selectedParticle.group != D3ComponentConst.comp_group10){	
					return ;
				}
			}else{
				return ;
			}
			
			var xs:String = JSON.stringify(D3SceneManager.getInstance().displayList.selectedParticle.configData.particleObj.getObject(true));
						
			//create xml
			var file:File = D3SceneManager.getInstance().displayList.selectedParticle.file;
			var w:D3WriteFile = new D3WriteFile();
			w.write(file,xs);
			
			saveTime_n2 = getTimer();
		}
		
		public function preParticle():ByteArray
		{
			if(D3SceneManager.getInstance().displayList.selectedParticle == null) return null;
			//saveParticle()
			var xs:String = JSON.stringify(D3SceneManager.getInstance().displayList.selectedParticle.configData.particleObj.getObject());
			return ByteArrayUtil.convertStringToByteArray(xs);
		}
		
		private static function get_App3DRightContainerMediator():App3DRightContainerMediator
		{
			return iManager.retrieveMediator(App3DRightContainerMediator.NAME) as App3DRightContainerMediator;
		}
		
		private static function get_App3DTopBarContainerMediator():App3DTopBarContainerMediator
		{
			return iManager.retrieveMediator(App3DTopBarContainerMediator.NAME) as App3DTopBarContainerMediator;
		}
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return iManager.retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
		
		protected static function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}
}