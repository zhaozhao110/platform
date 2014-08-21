package com.editor.d3.object
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessParticle;
	import com.sandy.utils.StringTWLUtil;


	public class D3ObjectParticle extends D3Object
	{
		public function D3ObjectParticle(from:int)
		{
			super(from);
			proccess = new D3ProccessParticle(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group10;
		}
		
		///////////////////////////////////// project ///////////////////////////
		
		//s : 文件的内容
		public function readParticle(s:String):void
		{
			if(!D3ResChangeProxy.getInstance().checkFile(file)){
				D3ResChangeProxy.getInstance().addFile(file,"");
			}
			configData = D3ResChangeProxy.getInstance().getFile(file.nativePath,true);
			configData.comp = this;
			configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(file))
			if(!StringTWLUtil.isWhitespace(name))configData.putAttri("name",name);
			configData.readParticle(s);
		}
		
		
		///////////////////////////////////// outline ///////////////////////////
		
		
	}
}