package com.editor.module_avg.pop.options
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_avg.event.AVGEvent;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.pop.AVGPopViewBase;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.module_avg.vo.sec.AVGSectionItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.SandyColorPickerBar;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class AVGOptionsPopView extends AVGPopViewBase
	{
		public function AVGOptionsPopView()
		{
			super();
		}
		
		private var nameTi:UITextInput;
		private var nameColBar:SandyColorPickerBar;
		private var conditionTI:UITextInput;
		private var secCB:UICombobox;
		
		private var editBtn:UIButton;
		private var okBtn:UIButton;
		private var optVBox:UIVBox;
		private var delBtn:UIButton;
		
		override protected function get poptitle():String
		{
			return "编辑选项";
		}
		
		override protected function create_init():void
		{			
			super.create_init();
			/////////////////////////////////////////////////////////
			
			optVBox = new UIVBox();
			optVBox.styleName = "list"
			optVBox.width = 415;
			optVBox.height = 120;
			optVBox.labelField = "opts_info"
			optVBox.enabeldSelect = true;
			optVBox.addEventListener(ASEvent.CHANGE , onOptChange);
			addContentChild(optVBox);
			
			/////////////////////////////////////////////////////////
			
			var h:UIHBox = createHBox();
			
			var lb:UILabel = new UILabel();
			lb.text = "选项: "
			lb.width = 80;
			h.addChild(lb);
			
			nameTi = new UITextInput();
			nameTi.width = 200;
			h.addChild(nameTi);
			
			nameColBar = new SandyColorPickerBar();
			nameColBar.width = 80;
			nameColBar.height = 22;
			nameColBar.selectedColor = ColorUtils.white;
			h.addChild(nameColBar);
			
			/////////////////////////////////////////////////////////
			
			h = createHBox();
			
			lb = new UILabel();
			lb.text = "出现条件: "
			lb.width = 80;
			h.addChild(lb);
			
			conditionTI = new UITextInput();
			conditionTI.width = 200;
			h.addChild(conditionTI);
			
			/////////////////////////////////////////////////////////
			
			h = createHBox();
			
			lb = new UILabel();
			lb.text = "跳转分段: "
			lb.width = 80;
			h.addChild(lb);
			
			secCB = new UICombobox();
			secCB.width = 150;
			secCB.height = 25;
			secCB.labelField = "name"
			secCB.dropDownHeight = 300;
			secCB.addEventListener(ASEvent.CHANGE,onLocChange);
			h.addChild(secCB);
			
			editBtn = new UIButton();
			editBtn.label = "修改"
			editBtn.addEventListener(MouseEvent.CLICK , onEditClick);
			h.addChild(editBtn);
			
			okBtn = new UIButton();
			okBtn.label = "添加"
			okBtn.addEventListener(MouseEvent.CLICK , onOkClick);
			h.addChild(okBtn);
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			delBtn.addEventListener(MouseEvent.CLICK , onDelBtn);
			h.addChild(delBtn);
			
			reflashContent()
		}
		
		override protected function onCloseHandle(e:MouseEvent):void
		{
			get_AVGModuleMediator().closeEditTxt();
			super.onCloseHandle(e);
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashContent()
		}
		
		override protected function uiHide():void
		{
			super.uiHide();
			nameTi.text = "";
			conditionTI.text = "";
			secCB.selectedIndex = -1;
		}
		
		private function reflashContent():void
		{
			secCB.dataProvider = AVGManager.getInstance().sectionList.section_ls
			secCB.selectedIndex = -1;
			optVBox.dataProvider = AVGManager.currFrame.opts_ls;
			optVBox.selectedIndex = -1;
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(nameTi.text)) return ;
			if(secCB.selectedItem == null) return ;
			var d:AVGSectionItemVO = secCB.selectedItem as AVGSectionItemVO;
			if(AVGManager.currSection!=null){
				if(AVGManager.currSection.name == d.name){
					return ;
				}
			}
			
			var op:AVGResData = new AVGResData();
			op.opts_cont = nameTi.text;
			op.opts_color = nameColBar.selectedColor;
			op.condition = conditionTI.text;
			op.jumpSectionName = d.name;
			AVGManager.currFrame.addOpts(op);
			
			optVBox.dataProvider = AVGManager.currFrame.opts_ls;
			optVBox.setSelectIndex(AVGManager.currFrame.opts_ls.length-1,true,true)
			AVGPreview.instance.reflashOpts();
			iManager.sendAppNotification(AVGEvent.reflashTimeline_inavg_event);
		}
		
		private function onLocChange(e:ASEvent):void
		{
			
		}
		
		private function onEditClick(e:MouseEvent):void
		{
			if(secCB.selectedItem == null) return ;
			var d:AVGSectionItemVO = secCB.selectedItem as AVGSectionItemVO;
			if(optVBox.selectedItem == null) return ;
			var op:AVGResData = optVBox.selectedItem as AVGResData;
			op.opts_cont 		= nameTi.text;
			op.opts_color	 	= nameColBar.selectedColor;
			op.condition 		= conditionTI.text;
			op.jumpSectionName 	= d.name;
			
			var s:int = optVBox.selectedIndex;
			optVBox.dataProvider = AVGManager.currFrame.opts_ls;
			optVBox.setSelectIndex(s,true,true);
			AVGPreview.instance.reflashOpts();
			iManager.sendAppNotification(AVGEvent.reflashTimeline_inavg_event);
		}
		
		private function onOptChange(e:ASEvent):void
		{
			if(optVBox.selectedItem == null) return ;
			var d:AVGResData = optVBox.selectedItem as AVGResData;
			nameTi.text = d.opts_cont;
			nameColBar.selectedColor = d.opts_color;
			conditionTI.text = d.condition;
			secCB.selectedIndex = AVGManager.getInstance().sectionList.getSectionIndex(d.jumpSectionName);
		}
		
		private function onDelBtn(e:MouseEvent):void
		{
			//if(secCB.selectedItem == null) return ;
			var d:AVGSectionItemVO = secCB.selectedItem as AVGSectionItemVO;
			if(optVBox.selectedItem == null) return ;
			var op:AVGResData = optVBox.selectedItem as AVGResData;
			AVGManager.currFrame.removeOpts(op.opts_cont);
			
			optVBox.dataProvider = AVGManager.currFrame.opts_ls;
			optVBox.setSelectIndex(AVGManager.currFrame.opts_ls.length-1,true,true)
			AVGPreview.instance.reflashOpts();
			iManager.sendAppNotification(AVGEvent.reflashTimeline_inavg_event);
				
		}
		
	}
}