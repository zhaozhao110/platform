package com.editor.module_map.popup.screenEditor
{	
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.proxy.MapEditorProxy;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_roleEdit.proxy.PeopleImageProxy;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class SceneEditorPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SceneEditorPopupwinMediator";
		
		private var sceneVo:MapSceneItemVO;
		
		public function SceneEditorPopupwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get mainUI():SceneEditorPopupwin
		{
			return viewComponent as SceneEditorPopupwin;
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
		public function get input5():UITextArea
		{
			return mainUI.input5;
		}
		public function get btn3():UIButton
		{
			return mainUI.btn3;
		}
		public function get img3():UIImage
		{
			return mainUI.img3;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			showReflash();
		}
		
		private function showReflash():void
		{
			sceneVo = null;
			if(OpenPopwinData(getOpenDataProxy()) != null){
				if(OpenPopwinData(getOpenDataProxy()).data is Object){
					var dataObj:Object = OpenPopwinData(getOpenDataProxy()).data as Object;
					if(dataObj.id)
					{
						sceneVo = MapEditorDataManager.getInstance().getScene(String(dataObj.id));
					}
				}
			}
			
			if(sceneVo)
			{
				input1.text = sceneVo.sourceId;
				input2.text = sceneVo.x + "";
				input3.text = sceneVo.y + "";
				input4.text = sceneVo.horizontalSpeed + "";
				input5.text = sceneVo.verticalMoveQueue;
				
				//renderFile(sceneVo.url);
			}else
			{
				input1.text = "";
				input2.text = "";
				input3.text = "";
				input4.text = "";
				input5.text = "";
			}
			
		}
		
		/**选择文件按钮点击**/
		public function reactToBtn3Click(e:MouseEvent):void
		{
			/*var map_type:FileFilter = new FileFilter("图像","*.jpg;*.jpeg;*.png");
			
			var file:File = new File();
			file.browse([map_type]);
			file.addEventListener(Event.SELECT, onFileSelectedHandle);*/
			
			
			/*var out:Array = [];
			var a:Array = get_PeopleImageProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str)){
					out.push(a[i]);
				}
			}
			
			var vo:SelectEditPopWinVO = new SelectEditPopWinVO();
			vo.data = out;
			vo.column2_dataField = "name1"
			vo.select_dataField = "item_ls"
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
			dat.data = vo;
			dat.callBackFun = selectedMotion
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);*/
			
		}
		
		private function selectedMotion(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			trace(item.id + item.name + "")
			//get_PeopleImageDataGridMediator().editMotion(item);
		}
		
		
		private function get_MapEditorProxy():MapEditorProxy
		{
			return retrieveProxy(MapEditorProxy.NAME) as MapEditorProxy;
		}
		
		private function onFileSelectedHandle(e:Event):void
		{
			var file:File = e.target as File;
			file.removeEventListener(Event.SELECT, onFileSelectedHandle);
			var fileUrl:String = file.url;
			input3.text = fileUrl;
			
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
			
			var loader:Loader = new Loader();
			loader.loadBytes(fileByte);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderCompleteHandle);
		}
		
		
		private function onLoaderCompleteHandle(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderCompleteHandle);
			var loader:Loader = loaderInfo.loader;
			
			var bitmap:Bitmap = loader.content as Bitmap;
			img3.width = bitmap.bitmapData.width;
			img3.height = bitmap.bitmapData.height;
			img3.addEventListener(Event.COMPLETE, img3CompleteHandle);
			img3.source = bitmap;
			
		}
		
		private function img3CompleteHandle(e:Event):void
		{
			img3.removeEventListener(Event.COMPLETE, img3CompleteHandle);
			
			img3.mouseEnabled = true;
			
			img3.removeEventListener(MouseEvent.MOUSE_DOWN, onMCMouseDownHandle);
			img3.addEventListener(MouseEvent.MOUSE_DOWN, onMCMouseDownHandle);
			img3.removeEventListener(MouseEvent.MOUSE_UP, onMCMouseUpHandle);
			img3.addEventListener(MouseEvent.MOUSE_UP, onMCMouseUpHandle);
		}
		
		private function onMCMouseDownHandle(e:MouseEvent):void
		{
			img3.startDrag(false);
		}
		private function onMCMouseUpHandle(e:MouseEvent):void
		{
			img3.stopDrag();
		}
		
		override protected function okButtonClick():void
		{
			if(input1.text == "" || input2.text == "" || input3.text == "" || input4.text == "" || input5.text == "")
			{
				showMessage("填写信息不完善！");
				return;
			}
			
			if(!sceneVo)
			{
				sceneVo = new MapSceneItemVO();
			}
			
			sceneVo.sourceId = input1.text;
			sceneVo.index = int(input2.text);
			/*sceneVo.url = input3.text;
			sceneVo.speedV = int(input4.text);
			sceneVo.speedH = int(input5.text);*/
			
			MapEditorDataManager.getInstance().addScene(sceneVo);
			
			sendAppNotification(MapEditorEvent.mapEditor_updateSceneList_event);
			
			closeWin();
		}
		
		override public function callDelPopWin():void
		{
			if(img3.content is Bitmap)
			{
				(img3.content as Bitmap).bitmapData.dispose();
				(img3.content as Bitmap).bitmapData = null;
			}
			img3.dispose();
		}
		

		
	}
}