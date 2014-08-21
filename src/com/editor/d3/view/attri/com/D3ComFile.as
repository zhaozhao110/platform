package com.editor.d3.view.attri.com
{
	import com.air.io.ReadImage;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UITextInput;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.process.D3ProccessAnim;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.process.D3ProccessMesh;
	import com.editor.d3.process.D3ProccessParticle;
	import com.editor.d3.process.D3ProccessTexture;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.event.AppEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.NumberUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class D3ComFile extends D3ComBase
	{
		public function D3ComFile()
		{
			super();
		}
		
		private var input:UITextInput;
		private var img:UIImage;
		private var preBtn:UIAssetsSymbol
		
		override protected function create_init():void
		{
			super.create_init();
			
			input = new UITextInput();
			input.height = 22
			input.editable = false;
			input.percentWidth = 100;
			//input.enterKeyDown_proxy = enterKeyDown
			addChild(input);
			
			img = new UIImage();
			img.source = "openFold_a"
			img.width = 18;
			img.height = 18;
			addChild(img);
			img.addEventListener(MouseEvent.CLICK , onClickHandle);
			
			preBtn = new UIAssetsSymbol();
			preBtn.source = "pre_a"
			preBtn.width = 18;
			preBtn.height = 18;
			preBtn.buttonMode = true;
			preBtn.addEventListener(MouseEvent.CLICK , onPreBtnClick);
			addChild(preBtn);
		}
		
		private function onPreBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(input.text)) return ;
			
			var f:File = new File(D3ProjectFilesCache.getInstance().addProjectResPath(input.text));
			if(!f.exists) return ;
			if(D3ReadImage.checkIsImage(f)){
				iManager.sendAppNotification(AppEvent.preImage_event,f.nativePath)
				return ;
			}
			if(item.expand == "texture" || item.expand == "material"){
				sendAppNotification(D3Event.select3DComp_event,D3SceneManager.getInstance().displayList.convertObject(f));
			}else if(item.expand == "image"){
				iManager.sendAppNotification(AppEvent.preImage_event,f.nativePath)
			}
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			comp.proccess.openViewGetFile(this,getFile);
		}
		
		private var selectedFile:File;
		private var selectedImg:*;
		
		private function getFile(f:File,b:*=null):void
		{
			selectedImg = b;
			selectedFile = f;
			input.text = D3ProjectFilesCache.getInstance().getProjectResPath(selectedFile);
			D3ProjectCache.dataChange = true;
			callUIRender();
		}
		
		override public function getValue():D3ComBaseVO
		{
			var d:D3ComBaseVO = new D3ComBaseVO();
			d.data = selectedFile
			d.data2 = selectedImg;
			return d;
		}
		
		override public function setValue():void
		{
			super.setValue();
			selectedFile = null;
			selectedImg = null;
			
			var v:* = getCompValue();
			input.text = v;
			input.toolTip = v;
			
			if(item.expand == "image" || item.expand == "texture" || item.expand == "material"){
				preBtn.visible = true;
			}else{
				preBtn.visible = false;
			}
		}
		
		
	}
}