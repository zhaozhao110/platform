package com.editor.moudule_drama.mediator.left.attributeEditor
{
	/**
	 * 影片帧属性
	 */	
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.left.DramaLeftContainerMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframeType;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameDialog;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameMovie;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameMovieVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class DramaAttributeEditor_FrameMovieMediator extends AppMediator
	{
		public static const NAME:String = "DramaAttributeEditor_FrameMovieMediator";
		
		private var vo:Drama_FrameMovieVO;;
		
		public function DramaAttributeEditor_FrameMovieMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaAttributeEditor_FrameMovie
		{
			return viewComponent as DramaAttributeEditor_FrameMovie;
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
		/**选择影片**/
		public function get input3():UITextInputWidthLabel
		{
			return mainUI.input3;
		}
		/**选择影片按钮**/
		public function get addRoleButton():UIButton
		{
			return mainUI.addRoleButton;
		}
		/**影片X**/
		public function get input4():UITextInputWidthLabel
		{
			return mainUI.input4;
		}
		/**影片Y**/
		public function get input5():UITextInputWidthLabel
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
			vo = pVo as Drama_FrameMovieVO;
			
			listenInputs(0);
			if(vo)
			{
				input2.selectedIndex = getInput2SelectIndex();
				input3.text = vo.movieId + "";
				input4.text = vo.movieX + "";
				input5.text = vo.movieY + "";
//				saveButton.label = "保存帧";
				saveButton.enabled = false;
				deleButton.visible = true;
			}else
			{
				input2.selectedIndex = -1;
				input3.text = "";
				input4.text = "";
				input5.text = "";
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
				vo.movieId = int(input3.text);
				vo.movieX = int(input4.text);
				vo.movieY = int(input5.text);
			}
		}
		
		/**侦听表单**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				input2.addEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input4.addEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				input5.addEventListener(FocusEvent.FOCUS_OUT, onInput5ChangeHandle);
			}else
			{
				input2.removeEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input4.removeEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				input5.removeEventListener(FocusEvent.FOCUS_OUT, onInput5ChangeHandle);
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
					vo = new Drama_FrameMovieVO();
					vo.id = DramaDataManager.getInstance().getKeyframeNewId() + "";
					vo.type = TimelineKeyframeType.FRAME_SOLID;
					vo.rowId = DramaDataManager.getInstance().selectedRowId;
					vo.frame = DramaDataManager.getInstance().selectedFrame;
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
				}
				
			}			
			
		}
		/**添加影片按钮**/
		public function reactToAddRoleButtonClick(e:MouseEvent):void
		{
			if(!this.vo)
			{
				showMessage("请先 插入帧！");
				return;
			}
			
			var out:Array = [];
			var a:Array = DramaManager.getInstance().get_DramaProxy().resInfo_ls.group_ls;
			for(var i:int=0;i<a.length;i++)
			{
				/**12<=影片**/
				if(AppResInfoGroupVO(a[i]).type != 12) continue;
				
				if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str))
				{
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
			dat.callBackFun = selectedSceneResCallBack
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}		
		private function selectedSceneResCallBack(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			input3.text = item.id + "";
			input3.toolTip = item.name1;
			
			var data:Drama_LoadingLayoutResData = new Drama_LoadingLayoutResData();
			data.loading_keyframeVO = vo;
			data.loading_resInfoItemVO = item;
			data.fileType = DramaConst.file_swf;
			data.loadingType = DramaConst.loading_movie;
			DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(data);
			
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
		private function onInput4ChangeHandle(e:FocusEvent):void
		{
			if(vo)
			{
				dataChange();
			}
		}
		private function onInput5ChangeHandle(e:FocusEvent):void
		{
			if(vo)
			{
				dataChange();
			}
		}
		
		
		
		
	}
}