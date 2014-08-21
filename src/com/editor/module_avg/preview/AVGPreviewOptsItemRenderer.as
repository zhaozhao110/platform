package com.editor.module_avg.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.module_avg.pop.preview.AVGPlayview;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.services.Services;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;
	
	public class AVGPreviewOptsItemRenderer extends UICanvas
	{
		public function AVGPreviewOptsItemRenderer()
		{
			super();
			create_init();
		}
		
		private var img:UIImage;
		private var txt:UILabel;
		
		private function create_init():void
		{
			width = 350;
			height = 31;
			
			img = new UIImage();
			img.source = Services.assets_fold_url + "/img/avg/bar.png"
			addChild(img);
			
			txt = new UILabel();
			txt.color = ColorUtils.white;
			txt.verticalCenter = 0;
			txt.horizontalCenter = 0;
			addChild(txt);
			
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = true
			addEventListener(MouseEvent.MOUSE_DOWN , onDownhandle);
		}
		
		public var item:AVGResData;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			item = value as AVGResData;
			txt.color = item.opts_color;
			txt.text = item.opts_cont;
			
		}
		
		private function onDownhandle(e:MouseEvent):void
		{
			if(AVGPlayview.instance == null) return ;
			if(!AVGPlayview.instance.visible) return ;
			e.stopImmediatePropagation();
			e.preventDefault();
			
			AVGPlayview.instance.jumpPlay(item);
		}
	}
}