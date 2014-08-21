package com.editor.module_avg.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.manager.DataManager;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.error.SandyError;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AVGPreview extends UICanvas
	{
		public function AVGPreview(_isPlay:Boolean=false)
		{
			super();
			isPlay = _isPlay;
			if(!isPlay){
				if(instance == null)instance = this;
			}
			create_init();
		}
		
		public var isPlay:Boolean;
		public static var instance:AVGPreview;
		public var backgroundCont:UICanvas;
		public var peopleCont:UICanvas;
		public var topCont:UICanvas;
		public var dialogCont:AVGPreviewDialog;
		public var optsVBox:UIVBox;
		
		private function create_init():void
		{
			width = AVGConfigVO.instance.width;
			height = AVGConfigVO.instance.height;
			styleName = "uicanvas"
			backgroundColor = ColorUtils.black;
			if(!isPlay){
				verticalCenter = 0;
				horizontalCenter = 0;
			}
			
			mouseEnabled = true
			enabledMouseWheel = false;
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto
			if(!isPlay)dragAndDrop = true;
			
			backgroundCont = new UICanvas();
			backgroundCont.enabledPercentSize = true;
			addChild(backgroundCont);
			
			peopleCont = new UICanvas();
			peopleCont.enabledPercentSize = true;
			addChild(peopleCont);
						
			topCont = new UICanvas();
			topCont.enabledPercentSize = true;
			addChild(topCont);
			
			dialogCont = new AVGPreviewDialog(this);
			topCont.addChild(dialogCont);
			dialogCont.y = this.height-dialogCont.height;
			
			optsVBox = new UIVBox();
			optsVBox.verticalGap = 10;
			optsVBox.itemRenderer = AVGPreviewOptsItemRenderer;
			optsVBox.width = 350;
			optsVBox.verticalCenter = -50;
			optsVBox.horizontalCenter = 0;
			addChild(optsVBox);
			
			mouseEnabled = true;
			addEventListener(MouseEvent.CLICK , onClickHandle);
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			dialogCont.y = this.height-dialogCont.height;
		}
		
		override protected function onDragEnterHandle():Boolean
		{
			if(isPlay) return false;
			var ds:SandyDragSource = getDragSource() as SandyDragSource;
			if(ds == null) return false;
			if(ds.type == DataManager.dragAndDrop_avgLibView){
				return true;
			}
			return false;
		}
		
		override protected function registerDrag_mouseDown():void{}
		
		override protected function onDragDropHandle(e:Event):void
		{
			if(isPlay) return;
			e.stopImmediatePropagation();
			e.preventDefault();
			
			addRes((getDragSource().data as AVGResData).clone());
			iManager.iDragAndDrop.endDrag(true);
		}
		
		private var res_ls:Array = [];
		
		private function addRes(d:AVGResData):void
		{
			if(!isPlay){
				if(AVGManager.currSection == null){
					iManager.iPopupwin.showError("请先选择某一个分段");
					return ;
				}
				if(currFrame == null){
					iManager.iPopupwin.showError("请先选择某一帧");
					return ;
				}
				
				currFrame.addRes(d);
			}
			
			_addRes(d);
			
			if(!isPlay)sendAppNotification(AVGEvent.reflashOutline_inavg_event);
		}
		
		public function removeRes(d:AVGResData):void
		{
			if(!isPlay)currFrame.removeRes(d);
			if(getPreviewItem(d.id)!=null){
				getPreviewItem(d.id).dispose();
			}
			res_ls[d.id.toString()] = null;
			sortItemLevel();
			if(!isPlay)sendAppNotification(AVGEvent.reflashOutline_inavg_event);
		}
		
		private function _addRes(d:AVGResData):void
		{
			if(d.id == 0){
				SandyError.error("id=0");
				return ;
			}
			var v:AVGPreviewItem = new AVGPreviewItem(d,peopleCont,this);
			peopleCont.addChild(v.getDisplayObject());
			d.level = peopleCont.numChildren-1;
			if(v.getDisplayObject()!=null){
				v.getDisplayObject().visible = true;
			}
			if(isPlay){
				if(v.resData.isSound){
					sound_ls.push(v);
				}
			}
			res_ls[v.id.toString()] = v;
		}
		
		override public function dispose():void
		{
			removeAll();
			stopAllSound();
			dialogCont.visible = false;
			optsVBox.visible = false
		}
		
		public function getPreviewItem(d:int):AVGPreviewItem
		{
			return res_ls[d.toString()] as AVGPreviewItem;
		}
		
		public function removeAll():void
		{
			for each(var v:AVGPreviewItem in res_ls){
				if(v!=null&&v.getDisplayObject()!=null){
					v.getDisplayObject().visible = false;
				}
			}
			
			for each(v in res_ls){
				if(v!=null){
					if(isPlay){
						if(!v.resData.isSound){
							v.dispose();
						}
					}else{
						v.dispose();
					}
				}
			}
			res_ls = null;res_ls = [];
		}
		
		public function get currFrame():AVGFrameItemVO
		{
			return frame;
		}
		
		private var frame:AVGFrameItemVO;
		private var sound_ls:Array = [];
		
		public function stopAllSound():void
		{
			for(var i:int=0;i<sound_ls.length;i++){
				AVGPreviewItem(sound_ls[i]).stopSound();
			}
			sound_ls = null;sound_ls=[]
		}
		
		public function setFrame(d:AVGFrameItemVO):void
		{
			frame = d;
			sound_ls=null;sound_ls=[];
			removeAll();
			dialogCont.visible = false;
			if(d == null) return ;
			for(var i:int=0;i<d.res_ls.length;i++){
				_addRes(d.res_ls[i] as AVGResData);
			}
			for each(var v:AVGPreviewItem in res_ls){
				if(v!=null&&v.getDisplayObject()!=null){
					v.getDisplayObject().visible = true;
				}
			}
			dialogCont.setContent();
			reflashOpts()
		}
		
		public function sortItemLevel():void
		{
			if(isPlay) return ;
			for each(var v:AVGPreviewItem in res_ls){
				if(v!=null){
					v.reflashItemLevel();
				}
			}
		}
		
		public function reflashOpts():void
		{
			if(currFrame.opts_ls.length == 0){
				optsVBox.visible = false;
			}else{
				optsVBox.dataProvider = currFrame.opts_ls;
				optsVBox.visible = true;
			}
		}
		
		public var click_f:Function;
				
		private function onClickHandle(e:MouseEvent):void
		{
			if(!isPlay) return ;
			if(dialogCont.contTxt.isPlaying()){
				dialogCont.contTxt.setAll();
				return ;
			}
			if(click_f!=null) click_f();
		}
		
		public function setAllDialogContent():void
		{
			if(dialogCont.contTxt.isPlaying()){
				dialogCont.contTxt.setAll();
			}
		}
		
	}
}