package com.editor.moudule_drama.mediator.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.mediator.AppMediator;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameDialogMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameMovieMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameResRecordMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_FrameSceneMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_LayoutViewMediator;
	import com.editor.moudule_drama.mediator.left.attributeEditor.DramaAttributeEditor_RowMediator;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.view.left.DramaLeftContainer;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameDialog;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameMovie;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameResRecord;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameScene;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_LayoutView;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_Row;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutDisplayObject;
	import com.editor.moudule_drama.vo.drama.Drama_FrameClipVO;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class DramaLeftContainerMediator extends AppMediator
	{
		public static const NAME:String = "DramaLeftContainerMediator";
		private var _frameClipSelectedVO:Drama_FrameClipVO;
				
		public function DramaLeftContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaLeftContainer
		{
			return viewComponent as DramaLeftContainer;
		}
		public function get tabBar():UITabBar
		{
			return mainUI.tabBar;
		}
		public function get tabContainer1():UICanvas
		{
			return mainUI.tabContainer1;
		}
		public function get tabContainer2():UICanvas
		{
			return mainUI.tabContainer2;
		}
		/**片断添加按钮**/
		public function get addFrameClipButton():UIButton
		{
			return mainUI.addFrameClipButton;
		}
		/**片断列表**/
		public function get frameClipListVbox():UIVBox
		{
			return mainUI.frameClipListVbox;
		}
		/**片断上移按钮**/
		public function get frameClipUpButton():UIButton
		{
			return mainUI.frameClipUpButton;
		}
		/**片断下移按钮**/
		public function get frameClipDownButton():UIButton
		{
			return mainUI.frameClipDownButton;
		}
		/**属性切换**/
		public function get viewStack():UIViewStack
		{
			return mainUI.viewStack;
		}
		/**0	场景帧属性**/
		public function get attSceneFrame():DramaAttributeEditor_FrameScene
		{
			return mainUI.attSceneFrame;
		}
		/**1	人物帧属性**/
		public function get attResRecord():DramaAttributeEditor_FrameResRecord
		{
			return mainUI.attResRecord;
		}
		/**2	影片帧属性**/
		public function get attMovieFrame():DramaAttributeEditor_FrameMovie
		{
			return mainUI.attMovieFrame;
		}
		/**3	对话帧属性**/
		public function get attDialogFrame():DramaAttributeEditor_FrameDialog
		{
			return mainUI.attDialogFrame;
		}
		/**4	显示对象属性**/
		public function get attLayoutView():DramaAttributeEditor_LayoutView
		{
			return mainUI.attLayoutView;
		}
		/**4	层属性**/
		public function get attRow():DramaAttributeEditor_Row
		{
			return mainUI.attRow;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			/**注册帧属性面板**/
			registerMediator(new DramaAttributeEditor_FrameSceneMediator(attSceneFrame));
			registerMediator(new DramaAttributeEditor_FrameResRecordMediator(attResRecord));
			registerMediator(new DramaAttributeEditor_FrameMovieMediator(attMovieFrame));
			registerMediator(new DramaAttributeEditor_FrameDialogMediator(attDialogFrame));
			
			registerMediator(new DramaAttributeEditor_LayoutViewMediator(attLayoutView));
			
			registerMediator(new DramaAttributeEditor_RowMediator(attRow));
			
			tabBar.addEventListener(ASEvent.CHANGE, onTabBarChangeHandle);
			tabBar.selectedIndex = 0;
			
			frameClipListVbox.addEventListener(ASEvent.CHANGE, onFrameClipListVboxHandle);
			
		}
		/**页签切换**/
		private function onTabBarChangeHandle(e:ASEvent):void
		{
			switch(tabBar.selectedIndex)
			{
				case 0:
					tabContainer1.visible = true;
					tabContainer2.visible = false;
					break;
				case 1:
					tabContainer1.visible = false;
					tabContainer2.visible = true;					
					break;
			}
		}
		
		/**片段列表改变事件**/
		private function onFrameClipListVboxHandle(e:ASEvent):void
		{
			_frameClipSelectedVO = frameClipListVbox.selectedItem as Drama_FrameClipVO;
			if(_frameClipSelectedVO)
			{
				DramaDataManager.getInstance().setCurrentFrameClip(_frameClipSelectedVO);
				DramaManager.getInstance().get_DramaToolBarMediator().infoTxt3.htmlText = "当前片段：" + "<font color='#00CC00'><b>" + _frameClipSelectedVO.name + "</b></font>";
				
				sendNotification(DramaEvent.drama_updataTimeline_event);
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
			}
		}
		
		/**选择一帧事件**/
		public function respondToDramaSelectOneFrameEvent(noti:Notification):void
		{
			var data:Object = noti.getBody();
			var id:String;
			var rowId:String;
			var frame:int;
			
			if(data)
			{
				id = String(data.id);
				if(data.rowId)
				{
					rowId = data.rowId;
				}
				if(data.frame)
				{
					frame = data.frame;
				}
			}
			
			if(rowId && rowId != "" && frame)
			{
				tabBar.selectedIndex = 1;
				var rowType:int = DramaDataManager.getInstance().getRowTypeByRowId(rowId);
				var vo:ITimelineKeyframe_BaseVO = DramaDataManager.getInstance().getKeyFrame(id);
				switch(rowType)
				{
					case DramaDataManager.frameRowType1 :
						/**场景层**/
						viewStack.selectedIndex = 0;
						DramaManager.getInstance().get_DramaAttributeEditor_sceneFrameMediator().setData(vo);
						break;
					case DramaDataManager.frameRowType2 :
						/**人物层**/
						viewStack.selectedIndex = 1;
						DramaManager.getInstance().get_DramaAttributeEditor_resRecordMediator().setData(vo);
						break;
					case DramaDataManager.frameRowType3 :
						/**影片层**/
						viewStack.selectedIndex = 2;
						DramaManager.getInstance().get_DramaAttributeEditor_movieFrameMediator().setData(vo);
						break;
					case DramaDataManager.frameRowType4 :
						/**对话层**/
						viewStack.selectedIndex = 3;
						DramaManager.getInstance().get_DramaAttributeEditor_dialogFrameMediator().setData(vo);
						break;
				}
				
				DramaDataManager.getInstance().selectedRowId = rowId;
				DramaDataManager.getInstance().selectedFrame = frame;
			}else
			{
				DramaDataManager.getInstance().selectedRowId = "";
				DramaDataManager.getInstance().selectedFrame = 0;
			}
						
		
			
		}
		/**为时间轴插入关键帧		或重置关键帧**/
		public function insertKeyframe(vo:ITimelineKeyframe_BaseVO):void
		{
			DramaDataManager.getInstance().addKeyFrame(vo);
			
			sendNotification(DramaEvent.drama_insertKeyframe_event, {vo:vo});
		}
		/**为时间轴移除关键帧**/
		public function removeKeyframe(vo:ITimelineKeyframe_BaseVO):void
		{
			DramaDataManager.getInstance().removeKeyframe(String(vo.id));
			
			sendNotification(DramaEvent.drama_removeKeyframe_event, {vo:vo});
		}
		
				
		/**添加片段按钮**/
		public function reactToAddFrameClipButtonClick(e:MouseEvent):void
		{
			if(!DramaManager.getInstance().isEnabledToControl(1))
			{
				return;
			}
			
			var vo:Drama_FrameClipVO = new Drama_FrameClipVO();
			vo.id = DramaDataManager.getInstance().getFrameClipNewId();
			vo.name = "片断 " + vo.id;
			DramaDataManager.getInstance().addFrameClip(vo);
			updataFrameClipList();
		}
		/**更新片段列表**/
		public function updataFrameClipList():void
		{
			var a:Array = DramaDataManager.getInstance().getFrameClipArray();
			frameClipListVbox.dataProvider = a;
			
			frameClipListVbox.selectedIndex = -1;
			
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var curVO:Drama_FrameClipVO = a[i] as Drama_FrameClipVO;
				if(curVO && curVO == _frameClipSelectedVO)
				{
					frameClipListVbox.selectedIndex = i;
					break;
				}
			}
			
			sendNotification(DramaEvent.drama_updataLayoutViewList_event);
		}
		
		/**片断上移按钮点击**/
		public function reactToFrameClipUpButtonClick(e:MouseEvent):void
		{
			swapFrameClipIndex(-1);
		}
		/**片断下移按钮点击**/
		public function reactToFrameClipDownButtonClick(e:MouseEvent):void
		{
			swapFrameClipIndex(1);
		}
		/**调整片断顺序**/
		private function swapFrameClipIndex(slot:int):void
		{
			var vo:Drama_FrameClipVO = frameClipListVbox.selectedItem as Drama_FrameClipVO;
			if(vo)
			{
				DramaDataManager.getInstance().swapFrameClipIndex(vo, slot);
				updataFrameClipList();
			}
			
		}
		
		/**选择了一个显示对象事件**/
		public function respondToDramaSelectedViewEvent(noti:Notification):void
		{
			var data:Object = noti.getBody();
			if(data)
			{
				var lvo:Drama_LayoutViewBaseVO;
				var target:DLayoutDisplayObject;
				var keyframeVO:Drama_FrameResRecordVO;
				if(data.vo && data.vo is Drama_LayoutViewBaseVO)
				{
					lvo = data.vo as Drama_LayoutViewBaseVO;
				}
				if(data.target && data.target is DLayoutDisplayObject)
				{
					target = data.target as DLayoutDisplayObject;
				}
				
				if(!lvo || !target) return;
				
				DramaDataManager.getInstance().selectedRowId = lvo.rowId;
				
				keyframeVO = DramaDataManager.getInstance().getCurrentRangeKeyframe() as Drama_FrameResRecordVO;				
				if(keyframeVO)
				{
					var recordList:Array = keyframeVO.getPropertiesListArr();
					for each(var pvo:Drama_PropertiesBaseVO in recordList)
					{
						if(DramaManager.getInstance().getLayoutViewById(pvo.targetId) == target)
						{
							sendNotification(DramaEvent.drama_editViewProperties_event, {vo:lvo});
						}
					}
				}
			}
		}
		
		/**编辑显示对象属性事件**/
		public function respondToDramaEditViewPropertiesEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data)
			{
				if(data.vo && data.vo is Drama_LayoutViewBaseVO)
				{
					var layoutVO:Drama_LayoutViewBaseVO = data.vo as Drama_LayoutViewBaseVO;
					var propertyVO:Drama_PropertiesBaseVO = DramaDataManager.getInstance().getLayoutPropertiesVOByLayoutVO(layoutVO);
					if(propertyVO)
					{
						tabBar.selectedIndex = 1;
						viewStack.selectedIndex = 4;
						DramaManager.getInstance().get_DramaAttributeEditor_LayoutViewMediator().setData(propertyVO);
					}
					
				}
			}
		}
		
		/**选择了一个时间轴层事件**/
		public function respondToDramaSelectOneRowEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data)
			{
				var rowId:String;
				var frame:int;
				if(data.rowId)
				{
					rowId = data.rowId;
				}
				if(data.frame)
				{
					frame = data.frame;
				}
				
				if(rowId)
				{
					var rowVO:Drama_RowVO = DramaDataManager.getInstance().getRowById(rowId);
					if(rowVO)
					{
						tabBar.selectedIndex = 1;
						viewStack.selectedIndex = 5;
						DramaManager.getInstance().get_DramaAttributeEditor_RowMediator().setData(rowVO);					
					}
				}
				
			}
		}
		
				
	}
}