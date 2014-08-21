package com.editor.module_map.popup.screenResEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class SceneResEditorPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SceneEditorPopupwinMediator";
		
		private var sceneResVo:MapSceneResItemVO;
		private var previewMovieClip:MovieClip;
		
		public function SceneResEditorPopupwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get mainUI():SceneResEditorPopupwin
		{
			return viewComponent as SceneResEditorPopupwin;
		}
		public function get input1():UITextInput
		{
			return mainUI.input1;
		}
		public function get input2():UITextInput
		{
			return mainUI.input2;
		}
		public function get input3():UITextInput
		{
			return mainUI.input3;
		}
		public function get input4():UITextInput
		{
			return mainUI.input4;
		}
		public function get input5():UITextInput
		{
			return mainUI.input5;
		}
		public function get input6():UITextInput
		{
			return mainUI.input6;
		}
		public function get btn4():UIButton
		{
			return mainUI.btn4;
		}
		public function get mcContainer():UICanvas
		{
			return mainUI.mcContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			showReflash();
		}
		
		private function showReflash():void
		{
			sceneResVo = null;
			if(OpenPopwinData(getOpenDataProxy()) != null){
				if(OpenPopwinData(getOpenDataProxy()).data is Object){
					var dataObj:Object = OpenPopwinData(getOpenDataProxy()).data as Object;
					if(dataObj.id)
					{
						sceneResVo = MapEditorDataManager.getInstance().getSceneRes(String(dataObj.id));
					}
				}
			}
			
			if(sceneResVo)
			{
				input1.text = sceneResVo.sourceId;
				/*input2.text = sceneResVo.sceneId;
				input3.text = sceneResVo.index + "";
				input4.text = sceneResVo.url;
				input5.text = sceneResVo.x + "";
				input6.text = sceneResVo.y + "";*/
				
				//renderFile(sceneResVo.url);
				
			}else
			{
				input1.text = "";
				input2.text = "";
				input3.text = "";
				input4.text = "";
				input5.text = "";
				input6.text = "";
			}
			
		}
		/**选择文件按钮点击**/
		public function reactToBtn4Click(e:MouseEvent):void
		{
			var map_type:FileFilter = new FileFilter("特效文件","*.swf");
			
			var file:File = new File();
			file.browse([map_type]);
			file.addEventListener(Event.SELECT, onFileSelectedHandle);
			
		}
		
		private function onFileSelectedHandle(e:Event):void
		{
			var file:File = e.target as File;
			file.removeEventListener(Event.SELECT, onFileSelectedHandle);
			var fileUrl:String = file.url;
			input4.text = fileUrl;
			
			renderFile(fileUrl);
			file = null;			
		}
		
		private function renderFile(url:String):void
		{
			var nFile:File = new File();
			nFile.url = url;
			var fileByte:ByteArray = new ByteArray();
			var fs:FileStream = new FileStream();
			fs.open(nFile,FileMode.READ); 
			fs.readBytes( fileByte, 0, fs.bytesAvailable );
			fs.close();
			fs = null;
			nFile = null;
			
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			
			var loader:Loader = new Loader();
			loader.loadBytes(fileByte, loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderCompleteHandle);
		}
		
		private function onLoaderCompleteHandle(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderCompleteHandle);
			var loader:Loader = loaderInfo.loader;
			
			removeAllMC();
			
			if(loader && loader.content)
			{
				previewMovieClip = loader.content as MovieClip;
				if(previewMovieClip)
				{
					mcContainer.addChild(previewMovieClip);
					previewMovieClip.removeEventListener(MouseEvent.MOUSE_DOWN, onMCMouseDownHandle);
					previewMovieClip.addEventListener(MouseEvent.MOUSE_DOWN, onMCMouseDownHandle);
					previewMovieClip.removeEventListener(MouseEvent.MOUSE_UP, onMCMouseUpHandle);
					previewMovieClip.addEventListener(MouseEvent.MOUSE_UP, onMCMouseUpHandle);
				}
			}			
		}
		
		private function onMCMouseDownHandle(e:MouseEvent):void
		{
			previewMovieClip.startDrag(false);
		}
		private function onMCMouseUpHandle(e:MouseEvent):void
		{
			previewMovieClip.stopDrag();
		}
		
		/**确定按钮**/
		override protected function okButtonClick():void
		{
			if(input1.text == "" || input2.text == "" || input3.text == "" || input4.text == "" || input5.text == "" || input6.text == "")
			{
				showMessage("填写信息不完善！");
				return;
			}
			
			if(!sceneResVo)
			{
				sceneResVo = new MapSceneResItemVO();
			}
			
			sceneResVo.sourceId = input1.text;
			/*sceneResVo.sceneId = input2.text;
			sceneResVo.index = int(input3.text);
			sceneResVo.url = input4.text;
			sceneResVo.x = int(input5.text);
			sceneResVo.y = int(input6.text);*/
			
			MapEditorDataManager.getInstance().addSceneRes(sceneResVo);
			
			sendAppNotification(MapEditorEvent.mapEditor_updateSceneResList_event);
			
			closeWin();
			
		}
		private function removeAllMC():void
		{
			for(var i:int=mcContainer.numChildren-1;i>=0;i--)
			{
				if(mcContainer.getChildAt(i) is MovieClip)
				{
					var mc:MovieClip = mcContainer.getChildAt(i) as MovieClip;
					mc.stop();
					UIComponentUtil.stopAllInMovieClip(mc);
					mcContainer.removeChild(mc);
					mc = null;
				}
			}
		}
		override public function callDelPopWin():void
		{
			removeAllMC();
		}
		
		
		
		
	}
}