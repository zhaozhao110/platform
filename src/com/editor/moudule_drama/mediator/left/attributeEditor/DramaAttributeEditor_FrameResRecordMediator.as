package com.editor.moudule_drama.mediator.left.attributeEditor
{
	/**
	 * 资源帧属性
	 */	
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.DramaModuleMediator;
	import com.editor.moudule_drama.mediator.left.DramaLeftContainerMediator;
	import com.editor.moudule_drama.mediator.right.layout.DramaLayoutContainerMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframeType;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameDialog;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameResRecord;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	public class DramaAttributeEditor_FrameResRecordMediator extends AppMediator
	{
		public static const NAME:String = "DramaAttributeEditor_FrameResRecordMediator";
		
		private var vo:Drama_FrameResRecordVO;
		private var _resListVboxSelectedVO:Drama_PropertiesBaseVO;
		
		public function DramaAttributeEditor_FrameResRecordMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaAttributeEditor_FrameResRecord
		{
			return viewComponent as DramaAttributeEditor_FrameResRecord;
		}
		/**层类型**/
		public function get input1():UITextInputWidthLabel
		{
			return mainUI.input1;
		}
		/**帧类型**/
		public function get input2():UICombobox
		{
			return mainUI.input2;
		}
		/**脚本**/
		public function get input3():UITextInputWidthLabel
		{
			return mainUI.input3;
		}
		/**选择资源按钮**/
		public function get seleResButton():UIButton
		{
			return mainUI.seleResButton;
		}
		/**资源列表**/
		public function get resListVbox():UIVBox
		{
			return mainUI.resListVbox;
		}
		/**删除按钮**/
		public function get deleButton():UIButton
		{
			return mainUI.deleButton;
		}
		/**保存按钮**/
		public function get saveButton():UIButton
		{
			return mainUI.saveButton;
		}
		/**上移按钮**/
		public function get upButton():UIButton
		{
			return mainUI.upButton;
		}
		/**下移按钮**/
		public function get downButton():UIButton
		{
			return mainUI.downButton;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			input2.dataProvider = [
				{name:"普通帧", type:TimelineKeyframeType.FRAME_SOLID}
				,{name:"空白帧", type:TimelineKeyframeType.FRAME_HOLLOW}
				,{name:"补间帧", type:TimelineKeyframeType.FRAME_TWEEN}
			]
			input2.labelField = "name";
			
			resListVbox.addEventListener(ASEvent.CHANGE, onResListVboxChangeHandle);
						
		}
		/**资源列表选择事件**/
		private function onResListVboxChangeHandle(e:ASEvent):void
		{
			_resListVboxSelectedVO = resListVbox.selectedItem as Drama_PropertiesBaseVO;
			if(_resListVboxSelectedVO)
			{
				var target:DLayoutSprite = DramaManager.getInstance().getLayoutViewById(_resListVboxSelectedVO.targetId) as DLayoutSprite;
				if(target)
				{
					DramaManager.getInstance().get_DramaLayoutContainerMediator().unClickAllSprite();
					target.doClick();
				}
			}
			
		}
		
		/**设置当前数据**/
		public function setData(pVo:ITimelineKeyframe_BaseVO):void
		{
			vo = pVo as Drama_FrameResRecordVO;
			
			listenInputs(0);
			if(vo)
			{
				input2.selectedIndex = getInput2SelectIndex();
				input3.text = vo.script ? vo.script : "";
				saveButton.enabled = false;
				deleButton.visible = true;
				
				updataResListVbox();
				
			}else
			{
				input2.selectedIndex = -1;
				input3.text = "";
				saveButton.enabled = true;
				deleButton.visible = false;
				
				resListVbox.dataProvider = [];
			}
			resListVbox.selectedIndex = -1;
			
			listenInputs(1);
		}
		
		/**数据改变**/
		public function dataChange():void
		{
			if(vo)
			{
				vo.type = int((input2.selectedItem).type);
				vo.script = input3.text;
			}
		}
						
		/**侦听表单**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				input2.addEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input3.addEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
			}else
			{
				input2.removeEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input3.removeEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
			}
		}
		
		/**更新资源属性列表**/
		public function updataResListVbox():void
		{
			var a:Array = vo.getPropertiesListArr();
			a.reverse();
			resListVbox.dataProvider = a;
			
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var curVO:Drama_PropertiesBaseVO = a[i] as Drama_PropertiesBaseVO;
				if(curVO && curVO == _resListVboxSelectedVO)
				{
					resListVbox.selectedIndex = i;
					break;
				}
			}
		}
		
		/**获得当前帧类型 <下拉框> 索引**/
		private function getInput2SelectIndex():int
		{
			var outIndex:int;
			if(vo)
			{
				if(vo.type == TimelineKeyframeType.FRAME_SOLID)
				{
					outIndex = 0;
				}else if(vo.type == TimelineKeyframeType.FRAME_HOLLOW)
				{
					outIndex = 1;
				}else if(vo.type == TimelineKeyframeType.FRAME_TWEEN)
				{
					outIndex = 2;
				}else
				{
					outIndex = -1;
				}
			}
			
			return outIndex;
			
		}
		
		
		/** << clicks**/
		
		/**保存按钮点击**/
		public function reactToSaveButtonClick(e:MouseEvent):void
		{
			/**判断是否允许操作**/
			if(!DramaManager.getInstance().isEnabledToControl())
			{
				return;
			}
			
			var rowId:String = DramaDataManager.getInstance().selectedRowId;
			var frame:int = DramaDataManager.getInstance().selectedFrame;
			if(rowId != "" && frame > 0)
			{
				if(!vo)
				{
					vo = new Drama_FrameResRecordVO();
					vo.id = DramaDataManager.getInstance().getKeyframeNewId() + "";
					vo.type = TimelineKeyframeType.FRAME_SOLID;
					vo.rowId = DramaDataManager.getInstance().selectedRowId;
					vo.frame = DramaDataManager.getInstance().selectedFrame;
					
					var beforeVO:Drama_FrameResRecordVO =  DramaDataManager.getInstance().getBeforKeyframe(vo.rowId, vo.frame) as Drama_FrameResRecordVO;
					if(beforeVO)
					{
						var copyArr:Array = beforeVO.getPropertiesListArr();
						vo.setPropertiesList(deepCopyRecordList(copyArr));
					}
				}
				DramaManager.getInstance().get_DramaLeftContainerMediator().insertKeyframe(vo);
				
				deleButton.visible = true;
				
				setData(vo);
			}
			
		}
		/**删除按钮点击**/
		public function reactToDeleButtonClick(e:MouseEvent):void
		{
			var rowId:String = DramaDataManager.getInstance().selectedRowId;
			var frame:int = DramaDataManager.getInstance().selectedFrame;
			if(rowId != "" && frame > 0)
			{			
				var vo:ITimelineKeyframe_BaseVO = DramaDataManager.getInstance().getKeyframeByPlace(rowId, frame);
				if(vo)
				{
					DramaManager.getInstance().get_DramaLeftContainerMediator().removeKeyframe(vo);
					vo = null;
					setData(vo);
					sendNotification(DramaEvent.drama_updataLayoutViewList_event);
				}
				
			}
			
		}
		
		/**选择资源按钮点击**/
		public function reactToSeleResButtonClick(e:MouseEvent):void
		{
			if(!this.vo)
			{
				showMessage("请先 插入帧！");
				return;
			}
			
			var out:Array = [];
			if(DramaManager.getInstance().get_DramaProxy().resInfo_ls)
			{
				var a:Array = DramaManager.getInstance().get_DramaProxy().resInfo_ls.group_ls;
				for(var i:int=0;i<a.length;i++)
				{
					for(var j:int=0;j<DramaManager.layoutResTypeList.length;j++)
					{
						if(AppResInfoGroupVO(a[i]).type == DramaManager.layoutResTypeList[j])
						{
							if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str))
							{
								out.push(a[i]);
							}
						}
					}
					
				}
				
				var popVo:SelectEditPopWinVO = new SelectEditPopWinVO();
				popVo.data = out;
				popVo.column2_dataField = "name1"
				popVo.select_dataField = "item_ls"
				
				var dat:OpenPopwinData = new OpenPopwinData();
				dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
				dat.data = popVo;
				dat.callBackFun = selectedResCallBack
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				dat.openByAirData = opt;
				openPopupwin(dat);
			}
			
		}		
		private function selectedResCallBack(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			if(vo)
			{
				var data:Drama_LoadingLayoutResData = new Drama_LoadingLayoutResData();
				data.loading_resInfoItemVO = item;
				data.loading_keyframeVO = vo;
				data.fileType = DramaConst.file_jpg;
				data.loadingType = DramaConst.loading_res;
				DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(data);
								
			}else
			{
				showMessage("请先 插入帧！");
			}
		}
		
		/**上移按钮点击**/
		public function reactToUpButtonClick(e:MouseEvent):void
		{
			if(vo && _resListVboxSelectedVO)
			{
				vo.swapSceneResIndex(_resListVboxSelectedVO, 1);
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
				updataResListVbox();
			}
		}
		/**下移按钮点击**/
		public function reactToDownButtonClick(e:MouseEvent):void
		{
			if(vo && _resListVboxSelectedVO)
			{
				vo.swapSceneResIndex(_resListVboxSelectedVO, -1);
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
				updataResListVbox();
			}
		}
		
		/** << listens**/
		private function onInput2ChangeHandle(e:ASEvent):void
		{
			if(vo)
			{
				dataChange();
				DramaManager.getInstance().get_DramaLeftContainerMediator().insertKeyframe(vo);
			}
		}
		private function onInput3ChangeHandle(e:FocusEvent):void
		{
			dataChange();
		}
		
		/** << 事件**/
		/**新添加一个布局显示对象在关键帧上事件 **/
		public function respondToDramaAddNewLayoutViewToKeyFrameEvent(noti:Notification):void
		{
			var data:Object = noti.getBody() as Object;
			if(data)
			{
				if(data.keyframeVO)
				{
					var sendVO:Drama_FrameResRecordVO = data.keyframeVO as Drama_FrameResRecordVO;
					if(sendVO == vo)
					{
						setData(vo);
					}
				}
			}
		}
		
				
		/** << utils**/	
		private function deepCopyRecordList(list:Array):Array
		{
			var outArr:Array = [];
			
			var len:int = list.length;
			for(var i:int=0;i<len;i++)
			{
				if(list[i] && list[i] is ITimelineViewProperties_BaseVO)
				{
					var propVO:ITimelineViewProperties_BaseVO = (list[i] as ITimelineViewProperties_BaseVO).clone();
					if(propVO)
					{
						if(propVO is Drama_PropertiesBaseVO)
						{
							/**不复制过渡属性**/
							(propVO as Drama_PropertiesBaseVO).transition = 0;
						}
						
						outArr.push(propVO);
					}
				}
			}
			
			return outArr;
		}
		
	}
}