package com.editor.d3.view.attri.com
{
	import com.air.io.FileUtils;
	import com.editor.component.controls.UIButton;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.text.SandyAutoCompleteComboBox;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class D3ComAutoCompleteComboBox extends D3ComBase
	{
		public function D3ComAutoCompleteComboBox()
		{
			super();
		}
				
		protected var input:SandyAutoCompleteComboBox;
		private var editBtn:UIButton;
		
		override protected function create_init():void
		{
			super.create_init();
			
			input = new SandyAutoCompleteComboBox();
			input.height = 22
			input.percentWidth = 100;
			input.dropDownWidth = 180
			input.enterKeyDown_proxy = enterKeyDown;
			input.addEventListener(ASEvent.CHANGE,onSelectChange)
			addChild(input);
			
			editBtn = new UIButton();
			editBtn.label = "编辑"
			addChild(editBtn);
			editBtn.addEventListener(MouseEvent.CLICK , onEditClick);
		}
		
		private function onSelectChange(e:ASEvent):void
		{
			input.data = e.data;
			input.text = D3ProjectFilesCache.getInstance().getProjectResPath(File(e.data));
		}
		
		private function enterKeyDown():void
		{
			callUIRender();
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = createComBaseVO();
			if(key == "name"){
				if(!StringTWLUtil.isWhitespace(comp.proccess.suffix)){
					input.text = input.text + "." + comp.proccess.suffix;
				}
			}
			d.data = input.text;
			return d
		}
		
		override public function setValue():void
		{
			super.setValue();
			
			if(item.expand == "particle"){
				input.dataProvider = D3ProjectFilesCache.getInstance().getAllParticle();
				editBtn.visible = true;
				editBtn.includeInLayout = true
			}else{
				editBtn.visible = false
				editBtn.includeInLayout = false
			}
			
			var v:* = getCompValue();
			input.text = v;
		}
		
		private function onEditClick(e:MouseEvent):void
		{
			D3ProjectCache.dataChange = true;
			sendAppNotification(D3Event.select3DComp_event,D3SceneManager.getInstance().displayList.convertObject(new File(D3ProjectFilesCache.getInstance().addProjectResPath(input.text))));
			D3ProjectCache.dataChange = false
		}
		
	}
}