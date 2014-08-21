package com.editor.moudule_drama.mediator.left.attributeEditor
{
	/**
	 * 对话帧属性
	 */	
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.left.DramaLeftContainerMediator;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframeType;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameDialog;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameDialogVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotItemVO;
	import com.editor.moudule_drama.vo.drama.plot.DramaPlotListNodeVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class DramaAttributeEditor_FrameDialogMediator extends AppMediator
	{
		public static const NAME:String = "DramaAttributeEditor_FrameDialogMediator";
		
		private var vo:Drama_FrameDialogVO;
				
		public function DramaAttributeEditor_FrameDialogMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaAttributeEditor_FrameDialog
		{
			return viewComponent as DramaAttributeEditor_FrameDialog;
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
		/**选择左右**/
		public function get radios():UIRadioButtonGroup
		{
			return mainUI.radios;
		}
		/**选择对话**/
		public function get input3():UITextInputWidthLabel
		{
			return mainUI.input3;
		}
		/**选择对话按钮**/
		public function get plotButton():UIButton
		{
			return mainUI.plotButton;
		}
		/**对话类型**/
		public function get input6():UITextInputWidthLabel
		{
			return mainUI.input6;
		}
		/**对话内容**/
		public function get input5():UITextArea
		{
			return mainUI.input5;
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
		
		override public function onRegister():void
		{
			super.onRegister();
			
			input2.dataProvider = [
							{name:"普通帧", type:TimelineKeyframeType.FRAME_SOLID}
							,{name:"空白帧", type:TimelineKeyframeType.FRAME_HOLLOW}
							,{name:"补间帧", type:TimelineKeyframeType.FRAME_TWEEN}
			]
			input2.labelField = "name";
			
		}
				
		/**设置当前数据**/
		public function setData(pVo:ITimelineKeyframe_BaseVO):void
		{
			vo = pVo as Drama_FrameDialogVO;
			
			listenInputs(0);
			if(vo)
			{
				input2.selectedIndex = getInput2SelectIndex();
				radios.selectedValue = int(vo.dialogPlace);
				input3.text = vo.dialogId + "";
				
				var nodeId:int = DramaDataManager.getInstance().currentSelectedDramaItem.id;
				var item:DramaPlotItemVO = DramaManager.getInstance().get_DramaProxy().plot_ls.getPlotItem(vo.dialogId, nodeId);
				if(item)
				{
					input3.toolTip = item.name1;
					input5.text = item.content;
					input6.text = getDialogTypeStr(item.type);
				}
												
//				saveButton.label = "保存帧";
				saveButton.enabled = false;
				deleButton.visible = true;
			}else
			{
				input2.selectedIndex = -1;
				radios.selectedValue = 0;
				input3.text = "";
				input3.toolTip = "";
				input5.text = "";
				input6.text = "";
//				saveButton.label = "插入帧";
				saveButton.enabled = true;
				deleButton.visible = false;
			}
			
			listenInputs(1);
		}
		
		/**数据改变**/
		public function dataChange():void
		{
			if(vo)
			{
				vo.type = int((input2.selectedItem).type);
				vo.dialogPlace = int(radios.selectedValue);
				vo.dialogId = int(input3.text);
								
				var nodeId:int = DramaDataManager.getInstance().currentSelectedDramaItem.id;
				var item:DramaPlotItemVO = DramaManager.getInstance().get_DramaProxy().plot_ls.getPlotItem(vo.dialogId, nodeId);
				if(item)
				{
					input3.toolTip = item.name1;
					input5.text = item.content;
					input6.text = getDialogTypeStr(item.type);
				}
			}
		}
		
		/**侦听表单**/
		private function listenInputs(status:int):void
		{			
			if(status > 0)
			{
				radios.addEventListener(ASEvent.CHANGE, onRadiosChangeHandle);
				input2.addEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
			}else
			{
				radios.removeEventListener(ASEvent.CHANGE, onRadiosChangeHandle);
				input2.removeEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
			}
		}
		
		/**获得当前帧类型索引**/
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
		
		/**获取对话类型描述**/
		private function getDialogTypeStr(type:int):String
		{
			var out:String = "普通对话";
			if(type == 1)
			{
				out = "旁白";
			}
			return out;
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
					vo = new Drama_FrameDialogVO();
					vo.id = DramaDataManager.getInstance().getKeyframeNewId() + "";
					vo.type = TimelineKeyframeType.FRAME_SOLID;
					vo.rowId = DramaDataManager.getInstance().selectedRowId;
					vo.frame = DramaDataManager.getInstance().selectedFrame;
					vo.dialogPlace = int(radios.selectedValue);
					
					setData(vo);
				}
				
				DramaManager.getInstance().get_DramaLeftContainerMediator().insertKeyframe(vo);
				
				deleButton.visible = true;
				
				dataChange();
				
			}
			
			
		}
		/**删除按钮点击**/
		public function reactToDeleButtonClick(e:MouseEvent):void
		{
			var rowId:String = DramaDataManager.getInstance().selectedRowId;
			var frame:int = DramaDataManager.getInstance().selectedFrame;
			if(rowId != "" && frame > 0)
			{				
				var vo:Drama_FrameDialogVO = DramaDataManager.getInstance().getKeyframeByPlace(rowId, frame) as Drama_FrameDialogVO;
				if(vo)
				{
					DramaManager.getInstance().get_DramaLeftContainerMediator().removeKeyframe(vo);
					vo = null;
					setData(vo);
				}
				
			}			
			
		}
		
		/**选择对话按钮点击**/
		public function reactToPlotButtonClick(e:MouseEvent):void
		{			
			if(!this.vo)
			{
				showMessage("请先 插入帧！");
				return;
			}
						
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = DramaManager.getInstance().get_DramaProxy().plot_ls.getPlotListNodeById(DramaDataManager.getInstance().currentSelectedDramaItem.id).list;
			vo.labelField = "name1";
			vo.label = "选择要插入的对话: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedDialogCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}		
		private function selectedDialogCallBack(item:DramaPlotItemVO,item1:SelectEditPopWin2VO):void
		{
			input3.text = item.id + "";
			
			dataChange();
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
		private function onRadiosChangeHandle(e:ASEvent):void
		{
			if(vo)
			{
				dataChange();
			}
		}
		
			
		
		
	}
}