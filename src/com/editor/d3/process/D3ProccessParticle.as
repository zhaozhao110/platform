package com.editor.d3.process
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemParticle;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.tool.D3ReadFile;
	import com.editor.d3.tool.D3WriteFile;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	
	import flash.filesystem.File;

	//project下面的粒子，有文件的
	public class D3ProccessParticle extends D3ProccessObject
	{
		public function D3ProccessParticle(d:D3ObjectParticle)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group10;
		}
		
		override public function get suffix():String
		{
			return D3ComponentConst.sign_5;
		}

		override public function comReflash(d:ID3ComBase):void
		{
			var dd:D3ComBaseVO = d.getValue();
			if(d.attriId == 44){
				//编辑粒子
				iManager.sendAppNotification(D3Event.editParticle_event,comp);
			}else if(d.attriId == 36){
				//particle
				saveAttri(d,dd);
				createParticle(dd.data);
			}else if(d.attriId == 39){
				//刷新缓存
				reflashParticleCache();
			}
			
			super.comReflash(d);
		}
		
		override public function createComp(checkSame:Boolean=false):Boolean
		{
			if(!comp.checkIsInProject()){
				return super.createComp(checkSame);
			}
			
			var f:File = getFile();
			if(f.exists){
				comp.file = f;
				var r:D3ReadFile = new D3ReadFile();
				(comp as D3ObjectParticle).readParticle(r.read(f.nativePath));
				return true;
			}
			var w:D3WriteFile = new D3WriteFile();
			w.write(f,"");
			comp.file = f;
			(comp as D3ObjectParticle).readParticle("");
			return true;
		}
		
		public function getFile():File
		{
			return comp.file;
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemParticle;
		}

		override public function getPreList(d:D3ComFile):Array
		{
			return D3ProjectFilesCache.getInstance().getAllParticle();
		}
		
		
	}
}