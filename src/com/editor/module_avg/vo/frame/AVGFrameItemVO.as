package com.editor.module_avg.vo.frame
{
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;

	/**
	 * 
	 * i:索引
	 * c:对话内容
	 * pn:讲话的人
	 * pc:pn的颜色
	 * sd:是否显示对话框
	 * bl:对话框的位置（上，中，下）
	 * cl:文本的颜色
	 * sh:抖动
	 * child-i:帧
	 * child-li:选项
	 * 
	 */ 
	public class AVGFrameItemVO implements ICloneInterface
	{
		public function AVGFrameItemVO(x:XML=null)
		{
			if(x == null) return ;
			index = int(x.@i);
			content = XML(x.child("c")[0]).text();
			peoName = x.@pn;
			peoColor = x.@pc;
			//contentCol = x.@cd;
			showDialog = int(x.@sd);
			backLoc = int(x.@bl);
			shake = int(x.@sh) ==1?true:false;
			setColors(x.@cl);
			
			for each(var iX:XML in x.i)
			{
				var d:AVGResData = new AVGResData();
				d.setXML(iX);
				res_ls.push(d);
			}
			
			var liXML:XML = XML(x.child("li")[0]);
			if(liXML!=null){
				for each(iX in liXML.i)
				{
					d = new AVGResData();
					d.setOpsXML(iX);
					opts_ls.push(d);
				}
			}
		}
		
		public var shake:Boolean;
		public var index:int;
		public var content:String = ""
		public var showDialog:int=1;
			
		private var _peoName:String="";
		public function get peoName():String
		{
			return _peoName;
		}
		public function set peoName(value:String):void
		{
			_peoName = value;
			if(StringTWLUtil.isWhitespace(_peoName)){
				_peoName = ""
			}
		}
		
		private var _peoColor:*;
		public function get peoColor():*
		{
			return _peoColor;
		}
		public function set peoColor(value:*):void
		{
			_peoColor = value;
			if(StringTWLUtil.isWhitespace(peoColor)){
				_peoColor = ColorUtils.white;
			}
		}

		/*private var _contentCol:*;
		public function get contentCol():*
		{
			return _contentCol;
		}
		public function set contentCol(value:*):void
		{
			_contentCol = value;
			if(StringTWLUtil.isWhitespace(_contentCol)){
				_contentCol = ColorUtils.white;
			}
		}*/

		private var _backLoc:int;
		public function get backLoc():int
		{
			return _backLoc;
		}
		public function set backLoc(value:int):void
		{
			_backLoc = value;
			if(_backLoc <= 0){
				_backLoc = 3;
			}
		}

		public var color_ls:Array = [];
		public function addColor(obj:Object):void
		{
			var h:Boolean=false;
			for(var i:int=0;i<color_ls.length;i++){
				var ob:Object = color_ls[i]
				if(ob.from == obj.from && ob.end == obj.end){
					color_ls[i] = obj;
					h = true
					break;
				}
			}
			if(!h){
				color_ls.push(obj);
			}
			color_ls = color_ls.sortOn("from",Array.NUMERIC);
		}
		private function getColors():String
		{
			var out:Array = []
			for(var i:int=0;i<color_ls.length;i++){
				var obj:Object = color_ls[i]
				out.push(obj.from+"|"+obj.end+"|"+obj.color);
			}
			return out.join(",");
		}
		private function setColors(s:String):void
		{
			if(StringTWLUtil.isWhitespace(s)) return ;
			var a:Array = s.split(",");
			for(var i:int=0;i<a.length;i++){
				var b:Array = String(a[i]).split("|");
				var obj:Object = {};
				obj.from = b[0]
				obj.end = b[1]
				obj.color = b[2]
				addColor(obj);
			}
		}
		public function clearColors():void
		{
			color_ls=null;color_ls=[];
		}
		
		public function getXML():String
		{
			var x:String = '<f ';
			x += 'i="'+index+'" '
			x += 'pn="'+peoName+'" '
			x += 'pc="'+peoColor+'" '
			x += 'sd="'+showDialog+'" '
			//x += 'cd="'+contentCol+'" '
			x += 'bl="'+backLoc+'" '
			x += 'cl="'+getColors()+'" '
			x += 'sh="'+(shake==true?1:0)+'" '
			x += '>';
			x += "<c><![CDATA["+content+']]></c>'
			x += '<li>'
			for(var i:int=0;i<opts_ls.length;i++){
				x += AVGResData(opts_ls[i]).getOptXML();
			}
			x += "</li>"
			for(i=0;i<res_ls.length;i++){
				x += AVGResData(res_ls[i]).getXML();
			}
			x += "</f>"
			return x;
		}
		
		public var res_ls:Array = [];
		
		public function addRes(d:AVGResData):void
		{
			res_ls.push(d);
		}
				
		public function removeRes(d:AVGResData):void
		{
			for(var i:int=0;i<res_ls.length;i++){
				if(AVGResData(res_ls[i]).id == d.id){
					res_ls.splice(i,1);
					break;
				}
			}
		}
		
		public function sortRes():void
		{
			res_ls = res_ls.sortOn("level",Array.NUMERIC);
		}
		
		public var opts_ls:Array = [];
		
		public function addOpts(d:AVGResData):void
		{
			var op:AVGResData = getOpts(d.opts_cont);
			if(op!=null){
				op.opts_cont = d.opts_cont;
				op.opts_color = d.opts_color;
				op.condition = d.condition;
				op.jumpSectionName = d.jumpSectionName;
				return ;
			}
			opts_ls.push(d);
		}
		
		public function getOpts(n:String):AVGResData
		{
			for(var i:int=0;i<opts_ls.length;i++){
				if(AVGResData(opts_ls[i]).opts_cont == n){
					return opts_ls[i] as AVGResData
				}
			}
			return null;
		}
		
		public function removeOpts(cont:String):void
		{
			var op:AVGResData = getOpts(cont);
			if(op!=null){
				var n:int = opts_ls.indexOf(op);
				if(n >= 0){
					opts_ls.splice(n,1);
				}
			}
		}
		
		public function cloneObject():*
		{
			var f:AVGFrameItemVO = new AVGFrameItemVO();
			ToolUtils.clone(this,f);
			return f;
		}
		
	}
}