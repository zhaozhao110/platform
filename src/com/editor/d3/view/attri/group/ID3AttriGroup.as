package com.editor.d3.view.attri.group
{
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.math.HashMap;

	public interface ID3AttriGroup
	{
		function findGroupCell(d:D3GroupItemVO):D3AttriGroupCell;
		function maxGroupCell(g:D3AttriGroupCell):void
		function removeGroup(d:D3AttriGroupCell):void
		function comReflash(d:ID3ComBase):void
			
		function get attri_ls():Array
		function set attri_ls(value:Array):void
		
		function get comp():D3ObjectBase;
		function set comp(value:D3ObjectBase):void
		
		function get curr_attri_map():HashMap;
		function set curr_attri_map(value:HashMap):void
		
	}
}