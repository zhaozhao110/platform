package com.editor.moudule_drama.mediator.left.attributeEditor
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIHSlider;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UIRadioButtonGroup;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_actionMix.manager.ActionMixManager;
	import com.editor.module_actionMix.vo.ActionMixData;
	import com.editor.module_actionMix.vo.mix.ActionMixGroupVO;
	import com.editor.module_actionMix.vo.mix.ActionMixItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.module_skill.vo.skill.EditSkillItemVO;
	import com.editor.module_skill.vo.skillSeq.SkillSeqGroupVO;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.mediator.right.layout.DramaLayoutContainerMediator;
	import com.editor.moudule_drama.model.DramaConst;
	import com.editor.moudule_drama.proxy.DramaProxy;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_LayoutView;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_LoadingLayoutResData;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.layout.Drama_LayoutViewBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesRoleVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	/**
	 * 布局对象属性
	 * @author sun
	 * 
	 */	
	public class DramaAttributeEditor_LayoutViewMediator extends AppMediator
	{
		public static const NAME:String = "DramaAttributeEditor_LayoutViewMediator";
		
		private var vo:Drama_PropertiesBaseVO;
		
		public function DramaAttributeEditor_LayoutViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaAttributeEditor_LayoutView
		{
			return viewComponent as DramaAttributeEditor_LayoutView;
		}
		/**名称**/
		public function get input1():UITextInputWidthLabel
		{
			return mainUI.input1;
		}
		/**X**/
		public function get input3():UITextInputWidthLabel
		{
			return mainUI.input3;
		}
		/**Y**/
		public function get input4():UITextInputWidthLabel
		{
			return mainUI.input4;
		}		
		/**左右缩放**/
		public function get hbox1():UIHBox
		{
			return mainUI.hbox1;
		}
		/**上下缩放**/
		public function get hbox2():UIHBox
		{
			return mainUI.hbox2;
		}
		/**角度调整**/
		public function get hbox3():UIHBox
		{
			return mainUI.hbox3;
		}		
		/**左右缩放**/
		public function get slider1():UIHSlider
		{
			return mainUI.slider1;
		}
		/**上下缩放**/
		public function get slider2():UIHSlider
		{
			return mainUI.slider2;
		}
		/**角度调整**/
		public function get slider3():UIHSlider
		{
			return mainUI.slider3;
		}
		/**透明调整**/
		public function get slider4():UIHSlider
		{
			return mainUI.slider4;
		}
		
		/**左右缩放**/
		public function get slider1Input():UITextInput
		{
			return mainUI.slider1Input;
		}
		/**上下缩放**/
		public function get slider2Input():UITextInput
		{
			return mainUI.slider2Input;
		}
		/**角度调整**/
		public function get slider3Input():UITextInput
		{
			return mainUI.slider3Input;
		}
		/**透明调整**/
		public function get slider4Input():UITextInput
		{
			return mainUI.slider4Input;
		}
		/**是否过渡**/
		public function get checkBox1():UICheckBox
		{
			return mainUI.checkBox1;
		}
		/**是否过渡**/
		public function get input5():UITextInput
		{
			return mainUI.input5;
		}
		/**鼠标参数**/
		public function get input6():UITextInputWidthLabel
		{
			return mainUI.input6;
		}
		/**深度按钮 up**/
		public function get toUpButton():UIButton
		{
			return mainUI.toUpButton;
		}
		/**深度按钮 down**/
		public function get toDownButton():UIButton
		{
			return mainUI.toDownButton;
		}		
		/**锁定按钮**/
		public function get lockButton():UIButton
		{
			return mainUI.lockButton;
		}
		/**删除按钮**/
		public function get deleButton():UIButton
		{
			return mainUI.deleButton;
		}
		/**复制按钮**/
		public function get cloneButton():UIButton
		{
			return mainUI.cloneButton;
		}
		
		/**角色人物	容器**/
		public function get role_container():UIVBox
		{
			return mainUI.role_container;
		}
		/**角色人物	选择武器**/
		public function get role_selectBtn2():UIButton
		{
			return mainUI.role_selectBtn2;
		}
		/**角色人物	选择武器**/
		public function get role_selectInput2():UITextInput
		{
			return mainUI.role_selectInput2;
		}
		/**角色人物	选择普通动作**/
		public function get role_combox1():UICombobox
		{
			return mainUI.role_combox1;
		}
		/**角色人物	选择混合动作**/
		public function get role_combox2():UICombobox
		{
			return mainUI.role_combox2;
		}
		/**角色人物	选择技能 input**/
		public function get role_combox3Input():UITextInput
		{
			return mainUI.role_combox3Input;
		}
		/**角色人物	选择技能 button**/
		public function get role_combox3Button():UIButton
		{
			return mainUI.role_combox3Button;
		}
		
		/**角色人物	动作种类**/
		public function get role_radioButtonGroup1():UIRadioButtonGroup
		{
			return mainUI.role_radioButtonGroup1;
		}
		/**角色人物	动作各类0**/
		public function get role_radioButton0():UIRadioButton
		{
			return mainUI.role_radioButton0;
		}
		/**角色人物	动作各类1**/
		public function get role_radioButton1():UIRadioButton
		{
			return mainUI.role_radioButton1;
		}
		/**角色人物	动作各类2**/
		public function get role_radioButton2():UIRadioButton
		{
			return mainUI.role_radioButton2;
		}
		/**角色人物	方向**/
		public function get role_radioButtonGroup2():UIRadioButtonGroup
		{
			return mainUI.role_radioButtonGroup2;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			slider1.maximum = 1;
			slider1.minimum = 0;
			slider2.maximum = 1;
			slider2.minimum = 0;
			slider3.maximum = 360;
			slider3.minimum = 0;
			slider4.maximum = 1;
			slider4.minimum = 0;
			
			slider1.value = 1;
			slider2.value = 1;
			slider3.value = 0;
			slider4.value = 1;
			
			/**普通动作列表**/
			role_combox1.labelField = "type_str";
			ActionMixManager.init();
			var dt:ActionMixData = new ActionMixData();
			dt.type = "wu"
			dt.type_str = "无"
			var a:Array = [dt];
			a = a.concat(ActionMixManager.god_action_ls);
			role_combox1.dataProvider = a; 
			role_combox1.selectedIndex = 0;
			
			input1.enterKeyDown_proxy = input1KeyDown;
			
		}
		
		private function input1KeyDown():void
		{
			if(StringTWLUtil.isWhitespace(input1.text)){
				input1.text = vo.name;
				return ;
			}
			var t:Drama_LayoutViewBaseVO = DramaDataManager.getInstance().getLayoutVOByPropertiesVO(vo)
			if(t!=null){
				t.customName = input1.text;
			}
		}
		
		/**添加表单事件的侦听**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				input3.addEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
				input4.addEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				slider1.addEventListener(ASEvent.CHANGE, onSlider1ChangeHandle);
				slider2.addEventListener(ASEvent.CHANGE, onSlider2ChangeHandle);
				slider3.addEventListener(ASEvent.CHANGE, onSlider3ChangeHandle);
				slider4.addEventListener(ASEvent.CHANGE, onSlider4ChangeHandle);
				slider1Input.addEventListener(FocusEvent.FOCUS_OUT, onSlider1InputChangeHandle);
				slider2Input.addEventListener(FocusEvent.FOCUS_OUT, onSlider2InputChangeHandle);
				slider4Input.addEventListener(FocusEvent.FOCUS_OUT, onSlider4InputChangeHandle);
				
				checkBox1.addEventListener(ASEvent.CHANGE, onCheckBox1ChangeHandle);
				input6.addEventListener(FocusEvent.FOCUS_OUT, onInput6ChangeHandle);
				
				role_radioButtonGroup1.addEventListener(ASEvent.CHANGE, role_radioButtonGroup1ChangeHandle);
				role_radioButtonGroup2.addEventListener(ASEvent.CHANGE, role_radioButtonGroup2ChangeHandle);
				role_combox1.addEventListener(ASEvent.CHANGE , role_combox1ChangeHandle);
				role_combox2.addEventListener(ASEvent.CHANGE , role_combox2ChangeHandle);
			}else
			{
				input3.removeEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
				input4.removeEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				slider1.removeEventListener(ASEvent.CHANGE, onSlider1ChangeHandle);
				slider2.removeEventListener(ASEvent.CHANGE, onSlider2ChangeHandle);
				slider3.removeEventListener(ASEvent.CHANGE, onSlider3ChangeHandle);
				slider4.removeEventListener(ASEvent.CHANGE, onSlider4ChangeHandle);
				slider1Input.removeEventListener(FocusEvent.FOCUS_OUT, onSlider1InputChangeHandle);
				slider2Input.removeEventListener(FocusEvent.FOCUS_OUT, onSlider2InputChangeHandle);
				slider4Input.removeEventListener(FocusEvent.FOCUS_OUT, onSlider4InputChangeHandle);
				
				checkBox1.removeEventListener(ASEvent.CHANGE, onCheckBox1ChangeHandle);
				input6.removeEventListener(FocusEvent.FOCUS_OUT, onInput6ChangeHandle);
				
				role_radioButtonGroup1.removeEventListener(ASEvent.CHANGE, role_radioButtonGroup1ChangeHandle);
				role_radioButtonGroup2.removeEventListener(ASEvent.CHANGE, role_radioButtonGroup2ChangeHandle);
				role_combox1.removeEventListener(ASEvent.CHANGE , role_combox1ChangeHandle);
				role_combox2.removeEventListener(ASEvent.CHANGE , role_combox2ChangeHandle);
			}
		}
		
		
		/**重置数据**/
		public function setData(pVo:ITimelineViewProperties_BaseVO):void
		{		
			vo = pVo as Drama_PropertiesBaseVO;
			
			listenInputs(0);
						
			if(vo)
			{
				input1.text = vo.name ? vo.name : "";
				var t:Drama_LayoutViewBaseVO = DramaDataManager.getInstance().getLayoutVOByPropertiesVO(vo)
				if(t!=null && !StringTWLUtil.isWhitespace(t.customName)){
					input1.text = t.customName;
				}
				
				input3.text = vo.x + "";
				input4.text = vo.y + "";
				
				slider1Input.text = vo.scaleX + "";
				slider2Input.text = vo.scaleY + "";
				slider3Input.text = vo.rotation + "";
				slider4Input.text = vo.alpha + "";
				
				if(vo.scaleX <= 1 && vo.scaleX >=0)
				{					
					slider1.value = vo.scaleX;
				}else
				{
					slider1.value = 1;
				}
				if(vo.scaleY <= 1 && vo.scaleY >= 0)
				{					
					slider2.value = vo.scaleY;
				}else
				{
					slider2.value = 1;
				}
				slider3.value = vo.rotation;
				if(vo.alpha <= 1 && vo.alpha >=0)
				{					
					slider4.value = vo.alpha;
				}else
				{
					slider4.value = 1;
				}
				
				lockButton.label = (vo.locked == 0) ? "锁定" : "解锁";
				
				checkBox1.selected = (vo.transition > 0) ? true : false;
				input5.text = (vo.transition > 0) ? "是" : "否";
				
				input6.text = vo.mouseClickPara ? vo.mouseClickPara : "";
				
				/**动作技能框**/
				if(vo is Drama_PropertiesRoleVO)
				{
					var item:AppResInfoItemVO = vo.resItem;
					if(item)
					{
						if(item.isBattleMode)
						{
							role_radioButton1.enabled = true;
							role_radioButton2.enabled = true;
						}else
						{
							role_radioButton1.enabled = false;
							role_radioButton2.enabled = false;
						}
					}
					
					role_container.visible = true;
					
					/**混合动作列表**/
					var layoutVO:Drama_LayoutViewBaseVO = DramaDataManager.getInstance().getLayoutVOByPropertiesVO(vo);
					var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(layoutVO.sourceId);					
					if(DramaManager.getInstance().get_DramaProxy().mix_ls)
					{
						var g:ActionMixGroupVO = DramaManager.getInstance().get_DramaProxy().mix_ls.getGroupByActionGroup(resInfoItem.monsterType);
						if(g!=null){
							role_combox2.dataProvider = g.all_ls;
						}
					}
										
					
					role_selectInput2.text = (vo as Drama_PropertiesRoleVO).armName;
					role_selectInput2.toolTip = (vo as Drama_PropertiesRoleVO).armName;
					
					role_radioButtonGroup1.selectedValue = (vo as Drama_PropertiesRoleVO).actionType;
					role_radioButtonGroup2.selectedValue = (vo as Drama_PropertiesRoleVO).direction;
					
					/**设置combox值**/
					setRole_combox1Value((vo as Drama_PropertiesRoleVO).action);
					setRole_combox2Value((vo as Drama_PropertiesRoleVO).action);
					setRole_combox3Value((vo as Drama_PropertiesRoleVO).actionName);
					
				}else
				{
					role_container.visible = false;
				}
							
				
			}else
			{
				input1.text = "";
				input3.text = "";
				input4.text = "";
				
				slider1Input.text = 1 + "";
				slider2Input.text = 1 + "";
				slider3Input.text = 0 + "";
				slider4Input.text = 1 + "";
				
				slider1.value = 1;
				slider2.value = 1;
				slider3.value = 0;
				slider4.value = 1;
				
				lockButton.label = "锁定";
				
				input6.text = "";
				
				role_container.visible = false;
				
			}
						
			listenInputs(1);
						
		}
		
		
		/**数据改变**/
		private function dateChange():void
		{
			if(vo)
			{
				vo.x = int(input3.text);
				vo.y = int(input4.text);
				
				vo.scaleX = Number(slider1Input.text);
				vo.scaleY = Number(slider2Input.text);
				vo.rotation = int(slider3Input.text);
				if(Number(slider4Input.text) > 1)
				{
					slider4.value = 1;
				}else
				{
					vo.alpha = Number(Number(slider4Input.text).toFixed(2));
				}
				
				vo.transition = (checkBox1.selected) ? 1 : 0;
				input5.text = (vo.transition > 0) ? "是" : "否";
				vo.mouseClickPara = input6.text;
				
				/**动作技能框**/
				if(vo is Drama_PropertiesRoleVO)
				{
					/**方向**/
					(vo as Drama_PropertiesRoleVO).direction = int(role_radioButtonGroup2.selectedValue);
					
					/**0普通动作, 1混合动作 ,3技能**/
					(vo as Drama_PropertiesRoleVO).actionType = int(role_radioButtonGroup1.selectedValue);
					if(role_radioButtonGroup1.selectedValue == 0)
					{
						role_combox1.enabled = true;
						
						role_combox2.enabled = false;
						role_combox2.selectedIndex = -1;
						
						role_combox3Button.enabled = false;
						role_combox3Input.text = "";
						
						var curAction1:ActionMixData = role_combox1.selectedItem as ActionMixData;
						if(curAction1)
						{
							(vo as Drama_PropertiesRoleVO).action = curAction1.type;
							(vo as Drama_PropertiesRoleVO).actionName = curAction1.type_str;
						}
						
					}else if(role_radioButtonGroup1.selectedValue == 1)
					{
						role_combox1.enabled = false;
						role_combox1.selectedIndex = -1;
						
						role_combox2.enabled = true;
						
						role_combox3Button.enabled = false;
						role_combox3Input.text = "";
						
						var curAction2:ActionMixItemVO = role_combox2.selectedItem as ActionMixItemVO;
						if(curAction2)
						{
							(vo as Drama_PropertiesRoleVO).action = curAction2.id.toString();
							(vo as Drama_PropertiesRoleVO).actionName = curAction2.name;
						}
					}else if(role_radioButtonGroup1.selectedValue == 2)
					{
						role_combox1.enabled = false;
						role_combox1.selectedIndex = -1;
												
						role_combox2.enabled = false;
						role_combox2.selectedIndex = -1;
						
						role_combox3Button.enabled = true;
						
						(vo as Drama_PropertiesRoleVO).action = (vo as Drama_PropertiesRoleVO).action;
						role_combox3Input.text = (vo as Drama_PropertiesRoleVO).actionName;
					}
				}
				
				sendAppNotification(DramaEvent.drama_viewPropertiesChange_event, {vo:vo});
			}
			
		}
		
		/**设置值	普通动作combox**/
		private function setRole_combox1Value(value:String):void
		{
			if(role_radioButtonGroup1.selectedValue != 0)
			{
				role_combox1.selectedIndex = -1;
				role_combox1.enabled = false;
				return;
			}
			
			role_combox1.enabled = true;
			
			if(!value || value == "" || value == "undefined")
			{
				role_combox1.selectedIndex = -1;
				return;
			}
			
			var len:int = role_combox1.dataProvider.length;
			for(var i:int=0;i<len;i++)
			{
				var data:ActionMixData = role_combox1.dataProvider[i] as ActionMixData;
				if(data.type == value)
				{
					role_combox1.selectedIndex = i;
					break;
				}
			}
		}
		
		/**设置值	混合动作combox**/
		private function setRole_combox2Value(value:String):void
		{
			if(role_radioButtonGroup1.selectedValue != 1)
			{
				role_combox2.selectedIndex = -1;
				role_combox2.enabled = false;
				return;
			}
			
			role_combox2.enabled = true;
			
			if(!value || value == "" || value == "undefined")
			{
				role_combox2.selectedIndex = -1;
				return;
			}
			var len:int = role_combox2.dataProvider.length;
			for(var i:int=0;i<len;i++)
			{
				var data:ActionMixItemVO = role_combox2.dataProvider[i] as ActionMixItemVO;
				if(data.id.toString() == value)
				{
					role_combox2.selectedIndex = i;
					break;
				}
			}
		}
		
		/**设置值	技能input**/
		private function setRole_combox3Value(value:String):void
		{
			if(role_radioButtonGroup1.selectedValue != 2)
			{
				role_combox3Input.text = "";
				role_combox3Button.enabled = false;
				return;
			}
			
			role_combox3Button.enabled = true;
			
			if(!value || value == "" || value == "undefined")
			{
				role_combox3Input.text = "";
				return;
			}
			
			role_combox3Input.text = value;
			
		}
		
		
		/** << clicks**/
		
		/**深度按钮点击 up**/
		public function reactToToUpButtonClick(e:MouseEvent):void
		{
			var keyfVO:Drama_FrameResRecordVO = DramaDataManager.getInstance().getCurrentRangeKeyframe() as Drama_FrameResRecordVO;
			if(keyfVO)
			{
				keyfVO.swapSceneResIndex(vo, 1);
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
			}
		}
		/**深度按钮点击 down**/
		public function reactToToDownButtonClick(e:MouseEvent):void
		{
			var keyfVO:Drama_FrameResRecordVO = DramaDataManager.getInstance().getCurrentRangeKeyframe() as Drama_FrameResRecordVO;
			if(keyfVO)
			{
				keyfVO.swapSceneResIndex(vo, -1);
				sendNotification(DramaEvent.drama_updataLayoutViewList_event);
			}
		}
		/**锁定按钮点击**/
		public function reactToLockButtonClick(e:MouseEvent):void
		{
			if(vo)
			{
				vo.locked = (vo.locked > 0) ? 0 : 1;
				lockButton.label =(vo.locked > 0) ? "解锁" : "锁定";
				sendAppNotification(DramaEvent.drama_viewPropertiesChange_event, {vo:vo});
			}
		}
		/**删除按钮点击**/
		public function reactToDeleButtonClick(e:MouseEvent):void
		{
			var keyfVO:Drama_FrameResRecordVO = DramaDataManager.getInstance().getCurrentRangeKeyframe() as Drama_FrameResRecordVO;
			var rowId:String = DramaDataManager.getInstance().selectedRowId;
			var frame:int = DramaDataManager.getInstance().selectedFrame;
			if(keyfVO)
			{
				keyfVO.removePropertyVO(vo);
				sendNotification(DramaEvent.drama_selectOneFrame_event, {rowId:rowId, frame:frame});
			}
		}
		/**复制按钮点击**/
		public function reactToCloneButtonClick(e:MouseEvent):void
		{
			var layoutVO:Drama_LayoutViewBaseVO = DramaManager.getInstance().getLayoutViewById(vo.targetId).vo as Drama_LayoutViewBaseVO;			
			var keyfVO:Drama_FrameResRecordVO = DramaDataManager.getInstance().getCurrentRangeKeyframe() as Drama_FrameResRecordVO;
			var resInfoItem:AppResInfoItemVO = DramaManager.getInstance().get_DramaProxy().resInfo_ls.getResInfoItemByID(layoutVO.sourceId);
			var nVO:Drama_PropertiesBaseVO = vo.clone() as Drama_PropertiesBaseVO;
			nVO.x = nVO.x + 25;
			nVO.y = nVO.y + 25;
			
			var data:Drama_LoadingLayoutResData = new Drama_LoadingLayoutResData();
			data.loading_resInfoItemVO = resInfoItem;
			data.loading_keyframeVO = keyfVO;
			data.loading_propertyVO = nVO;
			data.loading_selectedStatus = 1;
			data.fileType = DramaConst.file_jpg;
			data.loadingType = DramaConst.loading_res;
			
			DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(data);			
		}
		
		/**选择武器按钮点击**/
		public function reactToRole_selectBtn2Click(e:MouseEvent):void
		{
			var out:Array = [];
			if(DramaManager.getInstance().get_DramaProxy().resInfo_ls)
			{
				var a:Array = DramaManager.getInstance().get_DramaProxy().resInfo_ls.group_ls;
				for(var i:int=0;i<a.length;i++)
				{
					/**7武器**/
					if(AppResInfoGroupVO(a[i]).type != 7) continue;
					
					if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str))
					{
						out.push(a[i]);
					}
				}
				
				var popVo:SelectEditPopWinVO = new SelectEditPopWinVO();
				popVo.data = out;
				popVo.column2_dataField = "name1"
				popVo.select_dataField = "item_ls"
				
				var dat:OpenPopwinData = new OpenPopwinData();
				dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
				dat.data = popVo;
				dat.callBackFun = selectedResCallBack;
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
				data.loading_propertyVO = vo;
				data.fileType = DramaConst.file_jpg;
				data.loadingType = DramaConst.loading_res;
				
				DramaManager.getInstance().get_DramaLayoutContainerMediator().loadSourceByItme(data);
				
			}else
			{
				showMessage("请先 插入帧！");
			}
		}
		
		/**选择技能按钮点击**/
		public function reactToRole_combox3ButtonClick(e:MouseEvent):void
		{
			var a:Array = DramaManager.getInstance().get_DramaProxy().skill_ls.list;
			for(var i:int=0;i<a.length;i++){
				var item:EditSkillItemVO = a[i] as EditSkillItemVO;
				var g:SkillSeqGroupVO = DramaManager.getInstance().get_DramaProxy().skillSeq_ls.getGroupBySkillId(item.id);
				if(g!=null){
					item.name1 = ColorUtils.addColorTool(item.name1,ColorUtils.red);
				}
			}
			
			var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
			vo.data = a
			vo.labelField = "name1";
			vo.label = "选择技能编辑: ";
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
			dat.data = vo;
			dat.callBackFun = selectedSkill;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			dat.openByAirData = opt;
			openPopupwin(dat);
		}
		private function selectedSkill(item:EditSkillItemVO,item1:SelectEditPopWin2VO):void
		{
			if(vo)
			{
				if(vo is Drama_PropertiesRoleVO)
				{
					(vo as Drama_PropertiesRoleVO).action = item.id.toString();
					(vo as Drama_PropertiesRoleVO).actionName = item.name;
					
					dateChange();
				}
			}			
		}
		
		
		/** << listens**/
		private function onInput3ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput4ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onSlider1ChangeHandle(e:ASEvent):void
		{
			slider1Input.text = slider1.value.toFixed(2);
			dateChange();
		}
		private function onSlider2ChangeHandle(e:ASEvent):void
		{
			slider2Input.text = slider2.value.toFixed(2);
			dateChange();
		}
		private function onSlider3ChangeHandle(e:ASEvent):void
		{
			slider3Input.text = int(slider3.value) + "";
			dateChange();
		}
		private function onSlider4ChangeHandle(e:ASEvent):void
		{
			slider4Input.text = slider4.value.toFixed(2);
			dateChange();
		}
		private function onSlider1InputChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onSlider2InputChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		
		private function onSlider4InputChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		
		private function onCheckBox1ChangeHandle(e:ASEvent):void
		{
			dateChange();
		}
		private function onInput6ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		
		private function role_radioButtonGroup1ChangeHandle(e:ASEvent):void
		{
			if(vo)
			{
				if(vo is Drama_PropertiesRoleVO)
				{
					if((vo as Drama_PropertiesRoleVO).actionType != int(role_radioButtonGroup1.selectedValue))
					{
						(vo as Drama_PropertiesRoleVO).action = "";
						(vo as Drama_PropertiesRoleVO).actionName = "";
					}
				}
			}
			dateChange();
		}
		private function role_radioButtonGroup2ChangeHandle(e:ASEvent):void
		{
			dateChange();
		}
		private function role_combox1ChangeHandle(e:ASEvent):void
		{
			dateChange();
		}
		private function role_combox2ChangeHandle(e:ASEvent):void
		{
			dateChange();
		}
		
		
		/** <<gets**/
		
		/**获得动作名称**/
		public function getActionName(action:String, actionType:int):String
		{
			var outStr:String;
			
			var a:Array;
			if(actionType == 0)
			{
				ActionMixManager.init();
				a = ActionMixManager.god_action_ls;
				for each(var am:ActionMixData in a)
				{
					if(am.type == action)
					{
						outStr = am.type_str;
					}
				}
				
			}else if(actionType == 2)
			{
				a = DramaManager.getInstance().get_DramaProxy().skill_ls.list;
				for each(var item:EditSkillItemVO in a)
				{
					if(item.id.toString() == action)
					{
						outStr = item.name;
						break;
					}
				}
			}else if(actionType == 3)
			{
				
			}
			
			
			
			return outStr;
			
		}
				
	}
}