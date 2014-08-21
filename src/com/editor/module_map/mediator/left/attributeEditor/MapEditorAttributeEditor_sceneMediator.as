package com.editor.module_map.mediator.left.attributeEditor
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_map.view.left.attributeEditor.MapEditorAttributeEditor_scene;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.FocusEvent;

	public class MapEditorAttributeEditor_sceneMediator extends AppMediator
	{
		public static const NAME:String = "MapEditorAttributeEditor_sceneMediator";
		private var vo:MapSceneItemVO;
		
		public function MapEditorAttributeEditor_sceneMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():MapEditorAttributeEditor_scene
		{
			return viewComponent as MapEditorAttributeEditor_scene;
		}
		public function get vbox():UIVBox
		{
			return mainUI.vbox;
		}
		public function get input1():UITextInputWidthLabel
		{
			return mainUI.input1;
		}
		public function get input2():UITextInputWidthLabel
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
		public function get input5():UITextInput
		{
			return mainUI.input5;
		}
		public function get input6():UITextArea
		{
			return mainUI.input6;
		}
		public function get input7():UITextInputWidthLabel
		{
			return mainUI.input7;
		} 
		public function get input8():UITextInputWidthLabel
		{
			return mainUI.input8;
		}
		public function get checkBox1():UICheckBox
		{
			return mainUI.checkBox1;
		}
		public function get checkBox2():UICheckBox
		{
			return mainUI.checkBox2;
		}
		public function get input9():UITextArea
		{
			return mainUI.input9;
		}
		/**出生点X**/
		public function get input10():UITextInputWidthLabel
		{
			return mainUI.input10;
		}
		/**出生点y**/
		public function get input11():UITextInputWidthLabel
		{
			return mainUI.input11;
		}
		
		
		
		override public function onRegister():void
		{
			super.onRegister();
						
		}
		
		/**添加表单事件的侦听**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				input2.addEventListener(FocusEvent.FOCUS_OUT, onInput2ChangeHandle);
				input3.addEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
				input4.addEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				input5.addEventListener(FocusEvent.FOCUS_OUT, onInput5ChangeHandle);
				input6.addEventListener(FocusEvent.FOCUS_OUT, onInput6ChangeHandle);
				input7.addEventListener(FocusEvent.FOCUS_OUT, onInput7ChangeHandle);
				input8.addEventListener(FocusEvent.FOCUS_OUT, onInput8ChangeHandle);
				input9.addEventListener(FocusEvent.FOCUS_OUT, onInput9ChangeHandle);
				input10.addEventListener(FocusEvent.FOCUS_OUT, onInput10ChangeHandle);
				input11.addEventListener(FocusEvent.FOCUS_OUT, onInput11ChangeHandle);
				
				checkBox1.addEventListener(ASEvent.CHANGE, onCheckBox1ChangeHandle);
				checkBox2.addEventListener(ASEvent.CHANGE, onCheckBox2ChangeHandle);
				
			}else
			{
				input2.removeEventListener(FocusEvent.FOCUS_OUT, onInput2ChangeHandle);
				input3.removeEventListener(FocusEvent.FOCUS_OUT, onInput3ChangeHandle);
				input4.removeEventListener(FocusEvent.FOCUS_OUT, onInput4ChangeHandle);
				input5.removeEventListener(FocusEvent.FOCUS_OUT, onInput5ChangeHandle);
				input6.removeEventListener(FocusEvent.FOCUS_OUT, onInput6ChangeHandle);
				input7.removeEventListener(FocusEvent.FOCUS_OUT, onInput7ChangeHandle);
				input8.removeEventListener(FocusEvent.FOCUS_OUT, onInput8ChangeHandle);
				input9.removeEventListener(FocusEvent.FOCUS_OUT, onInput9ChangeHandle);
				input10.removeEventListener(FocusEvent.FOCUS_OUT, onInput10ChangeHandle);
				input11.removeEventListener(FocusEvent.FOCUS_OUT, onInput11ChangeHandle);
				
				checkBox1.removeEventListener(ASEvent.CHANGE, onCheckBox1ChangeHandle);
				checkBox2.removeEventListener(ASEvent.CHANGE, onCheckBox2ChangeHandle);
			}
		}
		
		/**重置数据**/
		public function setData(pVo:MapSceneItemVO):void
		{
			listenInputs(0);
			
			if(pVo)
			{
				this.vo = pVo;
				
				input1.text = vo.sourceName ? vo.sourceName : "";
				input2.text = vo.x + "";
				input3.text = vo.y + "";
				if(vo.isDefault > 0)
				{
					vo.useHDefaultSpeed = 1;
					checkBox1.enabled = false;
					input4.editable = true;
					input4.text = vo.range ? vo.range : "";
					input10.text = vo.spawnX ? vo.spawnX+"" : "";
					input11.text = vo.spawnY ? vo.spawnY+"" : "";
					
					vbox.addChildAt(input10, 7);
					vbox.addChildAt(input11, 8);
				}else
				{
					checkBox1.enabled = true;
					input4.editable = false;
					input4.text = "";
					input10.text = "";
					input11.text = "";
					
					if(vbox.contains(input10)) vbox.removeChild(input10);
					if(vbox.contains(input11)) vbox.removeChild(input11);
				}
												
				checkBox2Change();
				
				
				input6.text = vo.verticalMoveQueue ? vo.verticalMoveQueue : "";
				input7.text = vo.width + "";
				input8.text = vo.height + "";
				
				checkBox1.selected = (vo.isDefault > 0) ? true : false;
				
				/**空层  特殊情况**/
				if(int(vo.sourceId) < 0)
				{
					/*vbox.addChildAt(input7, 3);
					vbox.addChildAt(input8, 4);*/
					input7.editable = true;
					input8.editable = true;
					
				}else
				{
					/*if(vbox.contains(input7)) vbox.removeChild(input7);
					if(vbox.contains(input8)) vbox.removeChild(input8);*/
					input7.editable = false;
					input8.editable = false;
				}
				
				input9.text = vo.rotationMoveQueue ? vo.rotationMoveQueue : "";
				
			}else
			{
				input1.text = "";
				input2.text = "";
				input3.text = "";
				input4.editable = false;
				input4.text = "";
				input5.text = "";
				input6.text = "";
				input7.text = "";
				input8.text = "";
				input9.text = "";
				input10.text = "";
				input11.text = "";
				
				checkBox1.selected = false;
			}
			
			listenInputs(1);
			
		}
		
		/**数据改变**/
		private function dateChange():void
		{
			if(vo)
			{
				vo.x = int(input2.text);
				vo.y = int(input3.text);
				vo.width = int(input7.text);
				vo.height = int(input8.text);
				vo.range = input4.text;
				vo.horizontalSpeed = Number(input5.text);
				vo.verticalMoveQueue = input6.text;
				vo.rotationMoveQueue = input9.text;
				vo.isDefault = (checkBox1.selected) ? 1 : 0;
				vo.useHDefaultSpeed = (checkBox2.selected) ? 0 : 1;
				if(vo.isDefault)
				{
					vo.spawnX = int(input10.text);
					vo.spawnY = int(input11.text);					
				}else
				{
					vo.spawnX = 0;
					vo.spawnY = 0;
				}
				
				sendNotification(MapEditorEvent.mapEditor_pripertiesDateChange_event, {vo:this.vo});
			}
			
			
		}
		
		/** << input listens **/
		private function onInput2ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput3ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput4ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput5ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput6ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput7ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput8ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput9ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput10ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onInput11ChangeHandle(e:FocusEvent):void
		{
			dateChange();
		}
		private function onCheckBox1ChangeHandle(e:ASEvent):void
		{			
			dateChange();
			if(vo && vo.isDefault > 0)
			{
				checkBox1.enabled = false;
				input4.editable = true;
				
				checkBox2Change();
				
				MapEditorDataManager.getInstance().setSceneBeDefault(vo);
				sendNotification(MapEditorEvent.mapEditor_updateSceneList_event);
			}
		}
		
		private function onCheckBox2ChangeHandle(e:ASEvent):void
		{			
			dateChange();
			checkBox2Change();
			
		}
		private function checkBox2Change():void
		{
			if(vo.isDefault)
			{
				input5.editable = true;
				input5.text = vo.horizontalSpeed + "";
				checkBox2.enabled = false;
				checkBox2.selected = false;
				checkBox2.toolTip = "";
			}else
			{
				checkBox2.enabled = true;
				if(vo.useHDefaultSpeed > 0)
				{
					input5.text = "";
					input5.editable = false;
					checkBox2.selected = false;
					checkBox2.toolTip = "点击可以自定义速度";
				}else
				{
					input5.editable = true;
					input5.text = vo.horizontalSpeed + "";
					checkBox2.selected = true;
					checkBox2.toolTip = "点击可以设为默认速度";		
				}
			}
			
		}
		
		
		
	}
}