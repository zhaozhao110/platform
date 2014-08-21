package com.editor.d3.process
{
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import away3d.utils.Cast;
	
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectTexture;
	import com.editor.d3.pop.preTexture.App3DPreTextureWin;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.tool.D3ReadFile;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.d3.tool.D3WriteFile;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.view.attri.preview.TexturePreview;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.event.AppEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	public class D3ProccessTexture extends D3CompProcessBase
	{
		public function D3ProccessTexture(d:D3ObjectTexture)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group6;
		}
		
		override public function get suffix():String
		{
			return D3ComponentConst.sign_8;
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.key == "name"){
				changeName(d,dd);
				saveAttri(d,dd);
				reflashAttriNow();
				reflashLeftTree()
			}else{
				saveAttri(d,dd)
				reflashPreview(d,dd)
			}
		}
		
		override protected function saveAttri(d:ID3ComBase,v:D3ComBaseVO):void
		{
			comp.configData.putAttri(d.key,v.data);
			comp.configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(d.comp.file))
			save();
		}
		
		public function getFile():File
		{
			return comp.file;
		}
		
		override public function createComp(checkSame:Boolean=false):Boolean
		{
			var f:File = getFile();
			if(f.exists){
				comp.file = f;
				var r:D3ReadFile = new D3ReadFile();
				(comp as D3ObjectTexture).readXml(r.read(f.nativePath));
				return true;
			}
			var w:D3WriteFile = new D3WriteFile();
			w.write(f,"");
			comp.file = f;
			(comp as D3ObjectTexture).readXml("");
			save();
			return true;
		}
		
		private function save():void
		{
			if(!comp.enSave) return ;
			var f:File = getFile();
			var x:String = comp.configData.getXMLString();
			var w:D3WriteFile = new D3WriteFile();
			w.write(f,x);
			D3ResChangeProxy.getInstance().changeContent(f.nativePath,x);
		}
				
		override public function openSource():void
		{
			get_D3SourcePopViewMediator().openImageFile(comp.file);
		}
		
		override public function openViewGetFile(d:D3ComFile,f:Function):void
		{
			D3ViewManager.getInstance().openView_texture(f);
		}
		
		public function getTexture():*
		{
			var compId:int = int(comp.configData.getAttri("compId"));
			if(compId == 32){
				return create_BitmapTexture();
			}else if(compId == 31){
				return create_BitmapCubeTexture();
			}
			return null;
		}
		
		public function create_BitmapCubeTexture():BitmapCubeTexture
		{
			var s1:String = comp.configData.getAttri("positiveX");
			var positiveX:BitmapData = Cast.bitmapData(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
			
			s1 = comp.configData.getAttri("negativeX");
			var negativeX:BitmapData = Cast.bitmapData(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
			
			s1 = comp.configData.getAttri("positiveY");
			var positiveY:BitmapData = Cast.bitmapData(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
			
			s1 = comp.configData.getAttri("negativeY");
			var negativeY:BitmapData = Cast.bitmapData(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
			
			s1 = comp.configData.getAttri("positiveZ");
			var positiveZ:BitmapData = Cast.bitmapData(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
			
			s1 = comp.configData.getAttri("negativeZ");
			var negativeZ:BitmapData = Cast.bitmapData(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
			
			var b:BitmapCubeTexture = new BitmapCubeTexture(positiveX,negativeX,positiveY,negativeY,positiveZ,negativeZ);
			return b;
		}
		
		private function create_BitmapTexture():BitmapTexture
		{
			var s1:String = comp.configData.getAttri("bitmapData");
			return Cast.bitmapTexture(D3ResChangeProxy.getInstance().getFile(D3ProjectFilesCache.getInstance().addProjectResPath(s1)).content);
		}
		
	}
}