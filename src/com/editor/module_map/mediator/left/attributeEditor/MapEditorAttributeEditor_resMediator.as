package com.editor.module_map.mediator.left.attributeEditor
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIHSlider;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.expand.UIComboBoxWithLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.mediator.left.MapEditorLeftContainerMediator;
	import com.editor.module_map.mediator.right.layout.MapEditorLayoutContainerMediator;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_map.proxy.MapEditorProxy;
	import com.editor.module_map.view.left.attributeEditor.MapEditorAttributeEditor_res;
	import com.editor.module_map.vo.map.MapResConfigItemVO;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.editor.module_map.vo.map.MapSceneResItemEffVO;
	import com.editor.module_map.vo.map.MapSceneResItemNpcVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.module_map.vo.map.interfaces.IMapSceneResVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class MapEditorAttributeEditor_resMediator extends AppMediator
	{
		public static const NAME:String = "MapEditorAttributeEditor_resMediator";
		private var vo:MapSceneResItemVO;
		
		public function MapEditorAttributeEditor_resMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorAttributeEditor_res
		{
			return viewComponent as MapEditorAttributeEditor_res;
		}
		
		public function get vbox():UIVBox
		{
			return mainUI.vbox;
		}
		public function get input1():UITextInputWidthLabel
		{
			return mainUI.input1;
		}
		public function get input2():UICombobox
		{
			return mainUI.input2;
		}
		public function get input3():UITextInputWidthLabel
		{
			return mainUI.input3;
		}
		public function get input4():UITextInputWidthLabel
		{
			return mainUI.input4;
		}
		public function get input6():UITextInputWidthLabel
		{
			return mainUI.input6;
		}
		public function get hbox1():UIHBox
		{
			return mainUI.hbox1;
		}
		public function get hbox2():UIHBox
		{
			return mainUI.hbox2;
		}
		public function get hbox3():UIHBox
		{
			return mainUI.hbox3;
		}
		public function get slider1():UIHSlider
		{
			return mainUI.slider1;
		}
		public function get slider2():UIHSlider
		{
			return mainUI.slider2;
		}
		public function get slider3():UIHSlider
		{
			return mainUI.slider3;
		}
		public function get slider1Input():UITextInput
		{
			return mainUI.slider1Input;
		}
		public function get slider2Input():UITextInput
		{
			return mainUI.slider2Input;
		}
		public function get slider3Input():UITextInput
		{
			return mainUI.slider3Input;
		}
		public function get toUpButton():UIButton
		{
			return mainUI.toUpButton;
		}
		public function get toDownButton():UIButton
		{
			return mainUI.toDownButton;
		}
		public function get deleButton():UIButton
		{
			return mainUI.deleButton;
		}
		public function get lockButton():UIButton
		{
			return mainUI.lockButton;
		}
		public function get cloneButton():UIButton
		{
			return mainUI.cloneButton;
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
			
			slider1.value = 1;
			slider2.value = 1;
			slider3.value = 0;
			
			
		}
		
		/**添加表单事件的侦听**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				input2.addEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input3.addEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
				input4.addEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				input6.addEventListener(FocusEvent.FOCUS_OUT, onInput6ChangeHandle);
				slider1.addEventListener(ASEvent.CHANGE, onSlider1ChangeHandle);
				slider2.addEventListener(ASEvent.CHANGE, onSlider2ChangeHandle);
				slider3.addEventListener(ASEvent.CHANGE, onSlider3ChangeHandle);
				slider1Input.addEventListener(FocusEvent.FOCUS_OUT, onSlider1InputChangeHandle);
				slider2Input.addEventListener(FocusEvent.FOCUS_OUT, onSlider2InputChangeHandle);
			}else
			{
				input2.removeEventListener(ASEvent.CHANGE, onInput2ChangeHandle);
				input3.removeEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
				input4.removeEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				input6.removeEventListener(FocusEvent.FOCUS_OUT, onInput6ChangeHandle);
				slider1.removeEventListener(ASEvent.CHANGE, onSlider1ChangeHandle);
				slider2.removeEventListener(ASEvent.CHANGE, onSlider2ChangeHandle);
				slider3.removeEventListener(ASEvent.CHANGE, onSlider3ChangeHandle);
				slider1Input.removeEventListener(FocusEvent.FOCUS_OUT, onSlider1InputChangeHandle);
				slider2Input.removeEventListener(FocusEvent.FOCUS_OUT, onSlider2InputChangeHandle);
			}
		}
		
		/**重置数据**/
		public function setData(pVo:MapSceneResItemVO):void
		{			
			listenInputs(0);
			
			if(pVo)
			{
				vo = pVo;
												
				var config:MapResConfigItemVO = get_MapEditorProxy().mapRes.getItemById(int(vo.id));
				if(config)
				{
					input1.text = config.name ?  config.name : "";
				}else
				{					
					input1.text = vo.sourceName ? vo.sourceName : "";
				}
				setInput2Value(vo.sceneId);
				input2.toolTip = (input2.selectedItem as MapSceneItemVO).sourceName ? (input2.selectedItem as MapSceneItemVO).sourceName : "";
				input3.text = vo.x + "";
				input4.text = vo.y + "";
								
				slider1Input.text = vo.scaleX + "";
				slider2Input.text = vo.scaleY + "";
				slider3Input.text = vo.rotation + "";
				
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
				
				lockButton.label = (vo.locked == 0) ? "锁定" : "解锁";
				
				
				/**NPC 特殊情况**/
				if(vo is MapSceneResItemNpcVO)
				{
					if(vbox.contains(hbox1)) vbox.removeChild(hbox1);
					if(vbox.contains(hbox2)) vbox.removeChild(hbox2);
					if(vbox.contains(hbox3)) vbox.removeChild(hbox3);
					
				}else
				{
					vbox.addChildAt(hbox1,4);
					vbox.addChildAt(hbox2,5);
					vbox.addChildAt(hbox3,6);
					
				}
				
				/**特效   特殊情况**/
				if(vo is MapSceneResItemEffVO)
				{
					vbox.addChildAt(input6,7);
					input6.text = (vo as MapSceneResItemEffVO).startFrame + "";
				}else
				{
					if(vbox.contains(input6)) vbox.removeChild(input6);
					input6.text = "";
				}
			
				
			}else
			{
				input1.text = "";
				input2.selectedIndex = -1;
				input2.toolTip = "";
				input3.text = "";
				input4.text = "";
				input6.text = "";
				
				slider1Input.text = 1 + "";
				slider2Input.text = 1 + "";
				slider3Input.text = 1 + "";
				
				slider1.value = 1;
				slider2.value = 1;
				slider3.value = 0;
				
				lockButton.label = "锁定";
				
			}
			
			listenInputs(1);
						
		}
		
		/**数据改变**/
		private function dateChange():void
		{
			if(vo)
			{
				if(input2.selectedIndex >= 0)
				{
					vo.sceneId = getInput2Value(input2.selectedIndex);
				}
				vo.x = int(input3.text);
				vo.y = int(input4.text);
				if(vo is MapSceneResItemEffVO)
				{
					(vo as MapSceneResItemEffVO).startFrame = int(input6.text);					
				}
				
				vo.scaleX = Number(slider1Input.text);
				vo.scaleY = Number(slider2Input.text);
				vo.rotation = int(slider3Input.text);
				
				sendNotification(MapEditorEvent.mapEditor_pripertiesDateChange_event, {vo:this.vo});
			}
			
		}
		
		private function getInput2Value(index:int):String
		{
			var val:String = "";
			var a:Array = input2.dataProvider as Array;
			if(a)
			{
				var fvo:MapSceneItemVO = a[index] as MapSceneItemVO;
				val = fvo.sourceId;
			}
			return val;
		}
		
		private function setInput2Value(str:String):void
		{
			var si:int = 0;
			var a:Array = MapEditorDataManager.getInstance().getSceneArray();
			input2.dataProvider = a;
			input2.labelField = "sourceName";
			if(a)
			{
				var len:int = a.length;
				for(var i:int=0;i<len;i++)
				{
					var fvo:MapSceneItemVO = a[i] as MapSceneItemVO;
					if(fvo.sourceId == str)
					{
						si = i;
						break;
					}
				}
			}
			
			input2.selectedIndex = si;
			
		}
		
		/**深度调整按钮**/
		public function reactToToUpButtonClick(e:MouseEvent):void
		{
			swapIndexBySlot(1);
		}
		public function reactToToDownButtonClick(e:MouseEvent):void
		{
			swapIndexBySlot(-1);
		}
		private function swapIndexBySlot(slot:int):void
		{
			if(vo)
			{
				MapEditorDataManager.getInstance().swapSceneResIndex(vo, slot);	
				sendAppNotification(MapEditorEvent.mapEditor_updateSceneResList_event);
			}
		}
		
		/**复制按钮**/
		public function reactToCloneButtonClick(e:MouseEvent):void
		{
			var nVo:MapSceneResItemVO;
			if(vo is MapSceneResItemNpcVO)
			{
				nVo = (vo as MapSceneResItemNpcVO).clone();
				
			}else if(vo is MapSceneResItemEffVO)
			{
				nVo = (vo as MapSceneResItemEffVO).clone();
			}
			
			nVo.id = "s" + MapEditorDataManager.getInstance().getSceneResNewId();
			nVo.index = MapEditorDataManager.getInstance().getSceneResNewIndex(vo.sceneId);
			nVo.x = nVo.x + 15;
			nVo.y = nVo.y + 15;			
			nVo.locked = 1;
			
			MapEditorDataManager.getInstance().addSceneRes(nVo);
			
			var item:AppResInfoItemVO = get_MapEditorProxy().resInfo_ls.getResInfoItemByID(int(nVo.sourceId));
			if(item)
			{
				get_MapEditorLayoutContainerMediator().loadSourceByItme(item, nVo, 1);
			}
			
		}
		
		/**锁定按钮**/
		public function reactToLockButtonClick(e:MouseEvent):void
		{
			if(vo)
			{
				vo.locked = (vo.locked==0) ? 1 : 0;
				if(vo.locked == 0)
				{
					lockButton.label = "锁定";
				}else
				{
					lockButton.label = "解锁";
				}
				
				dateChange();
			}
			
		}
		
		/**删除按钮**/
		public function reactToDeleButtonClick(e:MouseEvent):void
		{
			if(vo)
			{
				get_MapEditorLeftContainerMediator().tabBar.selectedIndex = 0;
				MapEditorDataManager.getInstance().removeSceneRes(vo.id);
				sendNotification(MapEditorEvent.mapEditor_updateSceneResList_event);
			}
		}
		
		/** << input listens **/
		private function onInput2ChangeHandle(e:ASEvent = null):void
		{
			dateChange();
			var a:Array = MapEditorDataManager.getInstance().getSceneResArrayByScene(vo.sceneId);
			vo.index = a.length - 1;
			MapEditorDataManager.getInstance().resetSceneResListIndexByScene(vo.sceneId);
		}
		private function onInput3ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput4ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput6ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onSlider1ChangeHandle(e:ASEvent = null):void
		{
			slider1Input.text = slider1.value.toFixed(2);
			dateChange();
		}
		private function onSlider2ChangeHandle(e:ASEvent = null):void
		{
			slider2Input.text = slider2.value.toFixed(2);
			dateChange();
		}
		private function onSlider3ChangeHandle(e:ASEvent = null):void
		{
			slider3Input.text = int(slider3.value) + "";
			dateChange();
		}
		private function onSlider1InputChangeHandle(e:ASEvent = null):void
		{
			dateChange();
		}
		private function onSlider2InputChangeHandle(e:ASEvent = null):void
		{
			dateChange();
		}
		
		/**<< gets **/
		public function get_MapEditorLeftContainerMediator():MapEditorLeftContainerMediator
		{
			return retrieveMediator(MapEditorLeftContainerMediator.NAME) as MapEditorLeftContainerMediator;
		}
		private function get_MapEditorLayoutContainerMediator():MapEditorLayoutContainerMediator
		{
			return retrieveMediator(MapEditorLayoutContainerMediator.NAME) as MapEditorLayoutContainerMediator;
		}
		private function get_MapEditorProxy():MapEditorProxy
		{
			return retrieveProxy(MapEditorProxy.NAME) as MapEditorProxy;
		}
		
		
		
	}
}