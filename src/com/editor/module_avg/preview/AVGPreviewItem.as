package com.editor.module_avg.preview
{ 
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UISwfLoader;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.popview.attri.AVGAttriComBaseVO;
	import com.editor.module_avg.popview.attri.com.AVGComBase;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.media.SandySound;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AVGPreviewItem
	{
		public function AVGPreviewItem(d:AVGResData,sp:DisplayObjectContainer,p:AVGPreview)
		{
			super();
			preview = p;
			resData = d;
			parentSp = sp;
			create_init();
		}
		
		private var preview:AVGPreview;
		
		public function get id():int
		{
			return resData.id;
		}
		
		private var parentSp:DisplayObjectContainer;
		public var resData:AVGResData;
		
		private function create_init():void
		{
			responder = new AVGPreviewItemResponder(this);
			if(resData.isImage){
				addImage();
			}else if(resData.isSwf){
				addSwf();
			}else if(resData.isSound){
				addSound();
			}
			
			if(resData.existAttri("x")){
				getDisplayObject().x = resData.getAttri("x");
			}
			if(resData.existAttri("y")){
				getDisplayObject().y = resData.getAttri("y");
			}
			if(resData.existAttri("alpha")){
				getDisplayObject().alpha = resData.getAttri("alpha");
			}
			
			addEvents()
		}
		
		public function getDisplayObject():ASComponent
		{
			if(resData.isImage){
				return img;
			}else if(resData.isSwf){
				return swf;
			}
			return null;
		}
		
		public function reflashItemLevel():void
		{
			if(preview.isPlay) return ;
			resData.level = getDisplayObject().parent.getChildIndex(getDisplayObject());
			preview.currFrame.sortRes();
		}
		
		public function setDisplayObject(ds:AVGComBase):void
		{
			if(preview.isPlay) return ;
			var d:AVGAttriComBaseVO = ds.getValue();
			
			if(ds.item.id == 7){
				//上移
				getDisplayObject().swapToUpLevel();
				AVGPreview.instance.sortItemLevel();
				return ;
			}else if(ds.item.id == 8){
				//下移
				getDisplayObject().swapToDownLevel()
				AVGPreview.instance.sortItemLevel();
				return ;
			}else if(ds.item.id == 9){
				//最上层
				getDisplayObject().swapToTop();
				AVGPreview.instance.sortItemLevel();
				return ;
			}else if(ds.item.id == 10){
				//最下层
				getDisplayObject().swapToBottom();
				AVGPreview.instance.sortItemLevel();
				return ;
			}else if(ds.item.id == 11){
				//隐藏
				getDisplayObject().visible = false;
				return ;
			}else if(ds.item.id == 12){
				//只显示该物体
				AVGPreview.instance.peopleCont.setAllChildVisible(false);
				getDisplayObject().visible = true;
				return ;
			}else if(ds.item.id == 13){
				//播放
				if(resData.isSound){
					addSound();
				}else if(resData.isSwf){
					if(swf!=null) swf.playAll();
				}
				return ;
			}else if(ds.item.id == 14){
				//暂停
				if(resData.isSound){
					if(sd!=null) stopSound();
				}else if(resData.isSwf){
					if(swf!=null) swf.stopAll();
				}
				return ;
			}else if(ds.item.id == 15){
				//音量
				if(resData.isSound){
					if(sd!=null)sd.setVolume(d.data);
				}
			}else if(ds.item.id == 16){
				//删除
				AVGPreview.instance.removeRes(resData);				
				return ;
			}else if(ds.item.id == 17){
				//显示全部
				AVGPreview.instance.peopleCont.setAllChildVisible(true);
				return ;
			}else if(ds.item.id == 18){
				//是否循环
				//stopSound();
			}
			
			resData.putAttri(ds.key,d.data);
			
			if(ds.key == "volume"){
				if(sd!=null){
					sd.setVolume(d.data);
				}
			}else if(ds.key == "isCycle"){
				/*stopSound();
				addSound();*/
			}else if(ds.item.id == 19){
				
			}else if(ds.item.id == 20){
				
			}else{
				getDisplayObject()[ds.key] = d.data;
			}
			
			if(ds.item.id == 18){
				addSound();
			}
		}
		
		public var responder:AVGPreviewItemResponder;
		
		private var img:UIImage;
		private function addImage():void
		{
			if(img == null){
				img = new UIImage();
				img.visible = false
				img.complete_fun = imgLoadComplete;
				parentSp.addChild(img);
			}
			img.source = resData.loadPath;
		}
		
		private function imgLoadComplete():void
		{
			if(preview.isPlay) return ;
			resData.putAttri("width",img.contentHolderWidth);
			resData.putAttri("height",img.contentHolderHeight);
			reflashAttri()
		}
		
		public function reflashAttri():void
		{
			if(preview.isPlay) return ;
			iManager.sendAppNotification(AVGEvent.reflashAttri_inavg_event,resData);
		}
		
		private var swf:UISwfLoader;
		private function addSwf():void
		{
			if(swf == null){
				swf = new UISwfLoader();
				swf.visible = false;
				swf.complete_fun = swfLoadComplete;
				parentSp.addChild(swf);
			}
			swf.source = resData.loadPath;
		}
		
		private function swfLoadComplete():void
		{
			swf.playAll();
			if(preview.isPlay) return ;
			resData.putAttri("width",swf.contentHolderWidth);
			resData.putAttri("height",swf.contentHolderHeight);
			iManager.sendAppNotification(AVGEvent.reflashAttri_inavg_event,resData);
		}
		
		private function addEvents():void
		{
			if(preview.isPlay) return ;
			if(getDisplayObject() == null) return ;
			getDisplayObject().addEventListener(MouseEvent.MOUSE_DOWN,onDownHandle);
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			if(preview.isPlay) return ;
			getDisplayObject().stage.addEventListener(MouseEvent.MOUSE_UP,onUpHandle);
			getDisplayObject().stage.addEventListener(Event.MOUSE_LEAVE , onUpHandle);
			getDisplayObject().stage.addEventListener(MouseEvent.MOUSE_MOVE , onMoveHandle);
			getDisplayObject().startDrag();
		}
		
		private function onMoveHandle(e:MouseEvent):void
		{
			if(preview.isPlay) return ;
			resData.putAttri("x",getDisplayObject().x);
			resData.putAttri("y",getDisplayObject().y);
			iManager.sendAppNotification(AVGEvent.reflashAttri_inavg_event,resData);
		}
		
		private function onUpHandle(e:*=null):void
		{
			if(preview.isPlay) return ;
			if(getDisplayObject() == null) return ;
			
			getDisplayObject().stage.removeEventListener(MouseEvent.MOUSE_UP,onUpHandle);
			getDisplayObject().stage.removeEventListener(Event.MOUSE_LEAVE , onUpHandle);
			getDisplayObject().stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMoveHandle);
			getDisplayObject().stopDrag();	
		}
		
		private var sd:SandySound;
		public function addSound():void
		{
			if(sd == null){
				sd = new SandySound();
			}
			sd.play(resData.loadPath,resData.getAttri("volume"),resData.getAttri("isCycle")==0?1:1000);
		}
		public function stopSound():void
		{
			if(sd != null){
				sd.stop();
			}
			sd = null;
		}
		public function soundIsPlaying():Boolean
		{
			return sd!=null;
		}
		
		public function dispose():void
		{
			onUpHandle();
			if(img != null){
				UIComponentUtil.removeMovieClipChild(null,img);
				img.unload();
			}
			img = null;
			if(swf != null){
				UIComponentUtil.removeMovieClipChild(null,swf);
				swf.unload();
			}
			swf = null;
			stopSound()
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}
}