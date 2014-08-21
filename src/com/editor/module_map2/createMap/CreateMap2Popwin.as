package com.editor.module_map2.createMap
{
	import com.air.io.SelectFile;
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class CreateMap2Popwin extends AppPopupWithEmptyWin
	{
		public function CreateMap2Popwin()
		{
			super()
			create_init();
		}
		
		public var form:UIForm;
		public var widthTI:UITextInput;
		public var heightTI:UITextInput;
		public var tileWidthTI:UITextInput;
		public var tileHeightTI:UITextInput;
		public var fileTI:UITextInput;
		public var fileBtn:UIButton;
		public var idTI:UITextInput;
		
		private function create_init():void
		{
			form = new UIForm();
			form.verticalGap = 5;
			form.y = 50;
			form.x = 20
			form.width = 480;
			form.height = 350;
			form.leftWidth = 100
			this.addChild(form);
			
			var form_a:Array = [];
			
			idTI = new UITextInput();
			idTI.width = 220
			idTI.height = 22
			idTI.formLabel = "地图id："
			idTI.text = "23"
			form_a.push(idTI);
			
			widthTI = new UITextInput();
			widthTI.width = 220
			widthTI.height = 22
			widthTI.formLabel = "地图宽度："
			widthTI.text = "3000"
			form_a.push(widthTI);
			
			heightTI = new UITextInput();
			heightTI.width = 220
			heightTI.height = 22
			heightTI.formLabel = "地图高度："
			heightTI.text = "1792"
			form_a.push(heightTI);
			
			tileWidthTI = new UITextInput();
			tileWidthTI.width = 220
			tileWidthTI.height = 22
			tileWidthTI.formLabel = "单元格宽度："
			tileWidthTI.text = "30"
			form_a.push(tileWidthTI);
			
			tileHeightTI = new UITextInput();
			tileHeightTI.width = 220
			tileHeightTI.height = 22
			tileHeightTI.formLabel = "单元格高度："
			tileHeightTI.text = "30"
			form_a.push(tileHeightTI);
			
			var hb:UIHBox = new UIHBox();
			hb.width = 220;
			hb.height = 30;
			hb.formLabel = "地图文件："
			form_a.push(hb);
			
			fileTI = new UITextInput();
			fileTI.width = 220;
			hb.addChild(fileTI);
			
			fileBtn = new UIButton();
			fileBtn.label = "选择"
			hb.addChild(fileBtn);
			fileBtn.addEventListener(MouseEvent.CLICK , onSelect);
			
			form.areaComponent = form_a;
			
		}
		
		private function onSelect(e:MouseEvent):void
		{
			var txtFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;");
			SelectFile.select("image",[txtFilter],onSelectResult);
		}
		
		private function onSelectResult(e:Event):void
		{
			fileTI.text = (e.target as File).nativePath;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 500;
			opts.height = 300;
			opts.title = "新建地图"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.CreateMap2Popwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new CreateMap2PopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(CreateMap2PopwinMediator.NAME)
		}
	}
}