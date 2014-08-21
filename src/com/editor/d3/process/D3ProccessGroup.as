package com.editor.d3.process
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;

	public class D3ProccessGroup extends D3CompProcessBase
	{
		public function D3ProccessGroup(d:D3ObjectGroup)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group5
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.key == "name"){
				changeName(d,dd);
				saveAttri(d,dd);
			}else if(d.item.expand == "sys"){
				saveAttri(d,dd);
			}
		}
		
		override public function createComp(checkSame:Boolean=false):Boolean
		{
			D3ObjectGroup(comp).readObject2();
			return super.createComp(checkSame);
		}
		
	}
}