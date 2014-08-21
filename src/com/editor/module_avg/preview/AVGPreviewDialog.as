package com.editor.module_avg.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.services.Services;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.text.TextFormat;

	public class AVGPreviewDialog extends UICanvas
	{
		public function AVGPreviewDialog(pre:AVGPreview)
		{
			super();
			preview = pre;
			create_init();
		}
		
		private var preview:AVGPreview;
		public var img:UIImage;
		public var nameTxt:UILabel
		public var contTxt:UIGapText;
		public var nameCont:UICanvas;
		public var img2:UIImage;
		
		private function create_init():void
		{
			width = AVGConfigVO.instance.width;
			//height = 190;
						
			img = new UIImage();
			img.width = AVGConfigVO.instance.width;
			img.height = 180;
			img.source = Services.assets_fold_url + "/img/avg/messageBack.png"
			addChild(img);
			img.y=10
			
			contTxt = new UIGapText();
			contTxt.color = ColorUtils.white;
			addChild(contTxt);
			contTxt.fontSize = 16;
			contTxt.letterSpacing = 3;
			contTxt.leading = 5
			contTxt.selectable = false;
			contTxt.x = 100;
			contTxt.y = 50;
			contTxt.width = 780;
			
			nameCont = new UICanvas();
			nameCont.y = -26
			addChild(nameCont);
			
			img2 = new UIImage();
			img2.width = 398;
			img2.height = 53
			img2.source = Services.assets_fold_url + "/img/avg/nameBack.png"
			nameCont.addChild(img2);
			
			nameTxt = new UILabel();
			nameTxt.color = ColorUtils.white;
			nameTxt.fontSize = 16;
			nameTxt.letterSpacing = 3;
			nameCont.addChild(nameTxt);
			nameTxt.x = 56;
			nameTxt.y = 20;
			nameTxt.width = 160
			nameTxt.textAlign = "center"
			
			visible = false;
		}
		
		public function setContent():void
		{
			nameTxt.color = preview.currFrame.peoColor;
			nameTxt.text = preview.currFrame.peoName;
			if(StringTWLUtil.isWhitespace(preview.currFrame.peoName)){
				nameCont.visible = false
			}else{
				nameCont.visible = true;
			}
			
			//contTxt.color = preview.currFrame.contentCol;
			contTxt.colors = preview.currFrame.color_ls
			if(preview.isPlay){
				contTxt.text = preview.currFrame.content;
			}else{
				contTxt.text2 = preview.currFrame.content;
			}
			
			if(StringTWLUtil.isWhitespace(preview.currFrame.content)){
				visible = false
			}else{
				visible = true
			}
			
			showBack(preview.currFrame.showDialog);
			
			laterLoc()
		}
		
		private function laterLoc():void
		{
			if(preview.currFrame.backLoc == 1){
				this.y = 25
			}else if(preview.currFrame.backLoc == 2){
				this.y = preview.height/2-this.height/2;
			}else{
				this.y = preview.height-height;
			}
		}
		
		public function showBack(v:int):void
		{
			img.visible = v==1?true:false;
			img2.visible = img.visible;
		}
		
	}
}