package com.editor.d3.process
{
	import com.air.io.SelectFile;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class D3ProccessAnim extends D3CompProcessBase
	{
		public function D3ProccessAnim(d:D3ObjectAnim)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group8;
		}
		
		override public function get suffix():String
		{
			return D3ComponentConst.sign_4;
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.key == "name"){
				changeName(d,dd);
				saveAttri(d,dd);
			}else if(d.attriId == 37){
				//播放
				D3ObjectAnim(comp).playAnim();
			}else if(d.attriId == 38){
				D3ObjectAnim(comp).stopAnim();
			}else if(d.attriId == 34){
				//delete
				deleteObject();
			}else{
				if(d.attriId == 50){
					//isDefault
					D3Object(D3ObjectAnim(comp).parentObject).setNotAllAnim();					
				}
				if(d.item.value == "button") return ;
				saveAttri(d,dd);
				reflashPreview(d,dd);
			}
		}
		
		override public function createComp(checkSame:Boolean=false):Boolean
		{
			D3ObjectAnim(comp).readAnim();
			return super.createComp(checkSame);
		}
		
		override public function selected():void
		{
			if(comp.fromUI == D3ComponentConst.from_project) return ;
			D3SceneManager.getInstance().currScene.selectObject(D3Object(D3ObjectAnim(comp).parentObject).proccess.mapItem.getObject());
		}
		
		override protected function putAttri_path():void
		{
			if(!comp.checkIsInProject()){
				D3ObjectAnim(comp).readAnim2();
			}else{
				super.putAttri_path();
			}
		}
		
		override public function getPreList(c:D3ComFile):Array
		{
			return D3ProjectFilesCache.getInstance().getAllAnim();
		}
		
		
	}
}