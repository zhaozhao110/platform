package com.editor.module_avg.popview.section.component
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.popview.section.AVGSectionViewMediator;
	import com.editor.module_avg.vo.sec.AVGSectionItemVO;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class AVGSectionViewItemRenderer extends ASHListItemRenderer
	{
		public function AVGSectionViewItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var ti:UITextInput;
		private var selBtn:UIButton;
		private var delBtn:UIButton;
		private var copyBtn:UIButton;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = false;
			paddingLeft =10;
			
			ti = new UITextInput();
			ti.width = 140;
			ti.enterKeyDown_proxy = tiEnter;
			addChild(ti);
			
			selBtn = new UIButton();
			selBtn.label = "选择"
			addChild(selBtn);
			selBtn.addEventListener(MouseEvent.MOUSE_DOWN , onSelectHandle);
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			addChild(delBtn);
			delBtn.addEventListener(MouseEvent.MOUSE_DOWN , onDelHandle);
			
			copyBtn = new UIButton();
			copyBtn.label = "复制"
			addChild(copyBtn);
			copyBtn.addEventListener(MouseEvent.MOUSE_DOWN , onCopyHandle);
		}
		
		public var section:AVGSectionItemVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			section = value as AVGSectionItemVO;
			ti.text = section.name;
			
			mouseChildren = true;
			mouseEnabled = false;
		}
		
		override protected function _listenerMouseDown():void{}
		
		private function tiEnter():void
		{
			if(StringTWLUtil.isWhitespace(ti.text)){
				ti.text = section.name;
			}else{
				if(AVGManager.getInstance().sectionList.getSection(ti.text)!=null){
					iManager.iPopupwin.showError("名字已经存在");
					return ;
				}
				section.name = ti.text;
			}
		}
		
		override public function select():void
		{
			super.select();
			if(AVGManager.currSection == null) return ;
			selBtn.visible = false
		}
		
		override public function noSelect():void
		{
			super.noSelect();
			selBtn.visible = true;
		}
		
		public function onSelectHandle(e:MouseEvent=null):void
		{
			AVGManager.currSection = section;
			iManager.sendAppNotification(AVGEvent.selectSection_inavg_event,section);
			dispatchSelect(true);
		}
		
		private function onDelHandle(e:MouseEvent):void
		{
			get_AVGSectionViewMediator().delSection(section);
		}
		
		private function onCopyHandle(e:MouseEvent):void
		{
			get_AVGSectionViewMediator().copy(section);
		}
		
		private function get_AVGSectionViewMediator():AVGSectionViewMediator
		{
			return iManager.retrieveMediator(AVGSectionViewMediator.NAME) as AVGSectionViewMediator;
		}
	}
}