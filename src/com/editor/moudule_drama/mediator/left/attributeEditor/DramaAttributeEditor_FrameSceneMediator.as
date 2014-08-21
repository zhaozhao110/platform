package com.editor.moudule_drama.mediator.left.attributeEditor
{
	/**
	 * 场景帧属性
	 */	
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.manager.MapEditorManager;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.moudule_drama.data.DramaConfig;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.left.DramaLeftContainerMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframeType;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_FrameScene;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class DramaAttributeEditor_FrameSceneMediator extends AppMediator
	{
		public static const NAME:String = "DramaAttributeEditor_FrameSceneMediator";
		
		private var loadingXMLUrl:String;
		
		private var vo:Drama_FrameSceneVO;
		
		public function DramaAttributeEditor_FrameSceneMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaAttributeEditor_FrameScene
		{
			return viewComponent as DramaAttributeEditor_FrameScene;
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
		/**场景**/
		public function get input3():UITextInputWidthLabel
		{
			return mainUI.input3;
		}
		/**选择场景按钮**/
		public function get sceneButton():UIButton
		{
			return mainUI.sceneButton;
		}
		/**场景位置**/
		public function get input4():UITextInputWidthLabel
		{
			return mainUI.input4;
		}
		/**是否振动**/
		public function get checkBox1():UICheckBox
		{
			return mainUI.checkBox1;
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
			vo = pVo as Drama_FrameSceneVO;
			
			listenInputs(0);
			if(vo)
			{
				input2.selectedIndex = getInput2SelectIndex();
				input3.text = vo.sceneId + "";
				input4.text = vo.sceneOffset + "";
				checkBox1.selected = (vo.shakeNow > 0) ? true : false;
				
//				saveButton.label = "保存帧";
				saveButton.enabled = false;
				deleButton.visible = true;
			}else
			{
				input2.selectedIndex = -1;
				input3.text = "";
				input4.text = "";
				checkBox1.selected = false;
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
				vo.sceneId = int(input3.text);
				vo.sceneOffset = int(input4.text);
				vo.shakeNow = checkBox1.selected ? 1 : 0;
				
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
			}
		}
		
		/**侦听表单**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				input2.addEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input4.addEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				checkBox1.addEventListener(ASEvent.CHANGE, onCheckBox1ChangeHandle);
			}else
			{
				input2.removeEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input4.removeEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				checkBox1.removeEventListener(ASEvent.CHANGE, onCheckBox1ChangeHandle);
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
					vo = new Drama_FrameSceneVO();
					vo.id = DramaDataManager.getInstance().getKeyframeNewId() + "";
					vo.type = TimelineKeyframeType.FRAME_SOLID;
					vo.rowId = DramaDataManager.getInstance().selectedRowId;
					vo.frame = DramaDataManager.getInstance().selectedFrame;
					vo.sceneId = int(input3.text);
					
					var beforeVO:Drama_FrameSceneVO =  DramaDataManager.getInstance().getBeforKeyframe(vo.rowId, vo.frame) as Drama_FrameSceneVO;
					if(beforeVO)
					{
						vo.sceneId = beforeVO.sceneId;
						vo.sceneBackgroundSourceId = beforeVO.sceneBackgroundSourceId;
						vo.sceneOffset = beforeVO.sceneOffset;
					}
					
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
				var vo:ITimelineKeyframe_BaseVO = DramaDataManager.getInstance().getKeyframeByPlace(rowId, frame);
				if(vo)
				{
					DramaManager.getInstance().get_DramaLeftContainerMediator().removeKeyframe(vo);
					vo = null;
					setData(vo);
				}
				
			}			
			
		}
		
		/**添加场景按钮点击**/
		public function reactToSceneButtonClick(e:MouseEvent):void
		{
			if(!this.vo)
			{
				showMessage("请先 插入帧！");
				return;
			}
			
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = DramaManager.getInstance().get_DramaProxy().mapDefine.getList();
			vo.labelField = "name1";
			vo.label = "选择要编辑的场景: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedSceneCallBack;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		/**添加场景按钮回调**/
		private function selectedSceneCallBack(item:AppMapDefineItemVO, item1:SelectEditPopWin2VO):void
		{
			sceneButton.enabled = false;
			
			input3.text = item.id + "";
			input3.toolTip = item.name1;
			
			if(DramaConfig.sceneBackgroundSourceType == DramaConst.backSource_pictrue)
			{
				vo.sceneBackgroundSourceId = item.id;
				loaderBackgroundSource(item.id, DramaConst.loading_background, DramaConst.file_jpg, DramaConfig.currProject.mapResUrl+ "map/" + item.id + ".jpg");
				
			}else if(DramaConfig.sceneBackgroundSourceType == DramaConst.backSource_inXMLByDefinition)
			{
				loadingXMLUrl = DramaConfig.currProject.mapConfigUrl + "map/" + item.id + ".xml";
				
				var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
				mutltLoadData.addXMLData(iResource.getLoadSourceData(loadingXMLUrl,false,false,false,LoadQueueConst.sourceCache_mode1));
				
				var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
				dt.multSourceData = mutltLoadData;
				dt.allLoadComplete_f = loadSceneXMLComplete;
				dt.loadErrorF = loadSceneXMLError;
				iResource.loadMultResource(dt);
			}
			
			dataChange();
		}
		private function loadSceneXMLComplete(e:*=null):void
		{
			var x:XML = XML(iCacheManager.getCompleteLoadSource(loadingXMLUrl));			
			var finded:Boolean;			
			
			/**场景层**/
			for each(var sXML:XML in x.s.i)
			{
				var isd:int = sXML.@df ? sXML.@df : 0;
				if(isd > 0)
				{
					var resId:String = sXML.@id ? sXML.@id : "";
					if(resId != "")
					{
						vo.sceneBackgroundSourceId = int(resId);
						loaderBackgroundSource(int(resId), DramaConst.loading_background, DramaConst.file_swfDefinition);
						finded = true;
						break;
					}
				}
			}
			
			loadingXMLUrl = "";
			sceneButton.enabled = true;
			
			if(!finded)
			{
				showMessage("XML中未找到背景图ID ！<br>" + x);
			}
		}
		private function loadSceneXMLError(e:*=null):void
		{
			showMessage("未加载到场景XML!");
			loadingXMLUrl = "";
			sceneButton.enabled = true;
		}
		
		private function loaderBackgroundSource(id:int, loadingType:int, fileType:int, fileUrl:String=""):void
		{
			var item:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(id);
			var data:Drama_LoadingLayoutResData = new Drama_LoadingLayoutResData();
			data.loading_keyframeVO = vo;
			data.loading_resInfoItemVO = item;
			data.fileType = fileType;
			data.fileUrl = fileUrl;
			data.loadingType = loadingType;
			DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(data);
			
			sceneButton.enabled = true;
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
		private function onCheckBox1ChangeHandle(e:ASEvent):void
		{
			if(vo)
			{
				dataChange();
			}
		}
				
		
		
	}
}