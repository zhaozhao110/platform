package com.editor.d3.view.attri
{
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.group.D3AttriGroupCell;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;

	public interface ID3ComBase
	{
		function get item():D3ComAttriItemVO
		function set item(value:D3ComAttriItemVO):void
		
		function get group():D3GroupItemVO
		function set group(value:D3GroupItemVO):void
		
		function get reflashFun():Function
		function set reflashFun(value:Function):void
		
		function get target():D3AttriGroupCell
		function set target(value:D3AttriGroupCell):void
		
		function get comp():D3ObjectBase
		function set comp(value:D3ObjectBase):void
			
		function getValue():D3ComBaseVO;
		function setValue():void;
		function get key():String
		function get attriId():int
		
	}
}