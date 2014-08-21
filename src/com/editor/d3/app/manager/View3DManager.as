package com.editor.d3.app.manager
{
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3KeybroadManager;
	import com.editor.d3.view.attri.D3AttriPopView;
	import com.editor.d3.view.attri.D3AttriPopViewMediator;
	import com.editor.d3.view.console.D3ConsolePopView;
	import com.editor.d3.view.console.D3ConsolePopViewMediator;
	import com.editor.d3.view.outline.D3OutlinePopView;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.d3.view.particle.ParticleAttriView;
	import com.editor.d3.view.particle.ParticleAttriViewMediator;
	import com.editor.d3.view.project.D3ProjectPopView;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;
	import com.editor.d3.view.source.D3SourcePopView;
	import com.editor.d3.view.source.D3SourcePopViewMediator;
	import com.editor.event.App3DEvent;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.sandy.manager.SandyManagerBase;

	public class View3DManager extends SandyManagerBase
	{
		private static var instance:View3DManager;
		public static function getInstance():View3DManager{
			if(instance == null){
				instance =  new View3DManager();
			}
			return instance;
		}
		
		public function openView(type:int):void
		{			
			if(type == DataManager.pop3d_outline){ 
				open3dOutline();
			}else if(type == DataManager.pop3d_attri){ 
				open3dAttri()
			}else if(type == DataManager.pop3d_project){ 
				open3dProject()
			}else if(type == DataManager.pop3d_console){ 
				open3dConsole()
			}else if(type == DataManager.pop3d_source){
				open3dSource();
			}else if(type == DataManager.pop3d_particle){
				open3dparticle();
			}
		}
		
		public function closeView(type:int):void
		{
			if(type == DataManager.pop3d_source){ 
				close3dSource();
			}else if(type == DataManager.pop3d_attri){ 
				close3dAttri()
			}else if(type == DataManager.pop3d_particle){ 
				close3dparticle();
			}
		}
		
		public function open3DViews():void
		{
			View3DManager.getInstance().openView(DataManager.pop3d_attri);
			View3DManager.getInstance().openView(DataManager.pop3d_source);
			View3DManager.getInstance().openView(DataManager.pop3d_outline);
			View3DManager.getInstance().openView(DataManager.pop3d_project);
			View3DManager.getInstance().openView(DataManager.pop3d_console);
		}
		
		
		///////////////// particle ///////////////
		
		private var particleView:ParticleAttriView;
		private var particleMediator:ParticleAttriViewMediator;
		
		private function open3dparticle():void
		{
			if(particleView!=null) {
				sendAppNotification(D3Event.open_view3d_event,particleView,DataManager.pop3d_particle.toString())	
				return ;
			}
			
			particleView = new ParticleAttriView();
			particleView.label = DataManager.tabLabel3d_particle
			sendAppNotification(D3Event.open_view3d_event,particleView,DataManager.pop3d_particle.toString())
			iManager.registerMediator(particleMediator = new ParticleAttriViewMediator(particleView));
		}
		
		private function close3dparticle():void
		{
			sendAppNotification(D3Event.close_view3d_event,particleView,DataManager.pop3d_particle.toString())
		}
		
		
		///////////////// source ///////////////
		
		private var sourceView:D3SourcePopView;
		private var sourceMediator:D3SourcePopViewMediator;
		
		private function open3dSource():void
		{
			if(sourceView!=null) {
				sendAppNotification(D3Event.open_view3d_event,sourceView,DataManager.pop3d_source.toString())	
				return ;
			}
			
			sourceView = new D3SourcePopView();
			sourceView.label = DataManager.tabLabel3d_source
			sendAppNotification(D3Event.open_view3d_event,sourceView,DataManager.pop3d_source.toString())
			iManager.registerMediator(sourceMediator = new D3SourcePopViewMediator(sourceView));
		}
		
		private function close3dSource():void
		{
			sendAppNotification(D3Event.close_view3d_event,sourceView,DataManager.pop3d_source.toString())
		}
		
		///////////////// outline ///////////////
		
		private var outlineView:D3OutlinePopView;
		private var outlineMediator:D3OutlinePopViewMediator;
		
		private function open3dOutline():void
		{
			if(outlineView!=null) {
				sendAppNotification(D3Event.open_view3d_event,outlineView,DataManager.pop3d_outline.toString())	
				return ;
			}
			
			outlineView = new D3OutlinePopView();
			outlineView.label = DataManager.tabLabel3d_outline
			sendAppNotification(D3Event.open_view3d_event,outlineView,DataManager.pop3d_outline.toString())
			iManager.registerMediator(outlineMediator = new D3OutlinePopViewMediator(outlineView));
		}
		
		private function close3dOutline():void
		{
			sendAppNotification(D3Event.close_view3d_event,outlineView,DataManager.pop3d_outline.toString())
		}
		
		///////////////// project ///////////////
		
		private var projectView:D3ProjectPopView;
		private var projectMediator:D3ProjectPopViewMediator;
		
		private function open3dProject():void
		{
			if(projectView!=null) {
				sendAppNotification(D3Event.open_view3d_event,projectView,DataManager.pop3d_project.toString())	
				return ;
			}
			
			projectView = new D3ProjectPopView();
			projectView.label = DataManager.tabLabel3d_project;
			sendAppNotification(D3Event.open_view3d_event,projectView,DataManager.pop3d_project.toString())
			iManager.registerMediator(projectMediator = new D3ProjectPopViewMediator(projectView));
		}
		
		private function close3dProject():void
		{
			sendAppNotification(D3Event.close_view3d_event,projectView,DataManager.pop3d_project.toString())
		}
		
		///////////////// attri ///////////////
		
		private var attriView:D3AttriPopView;
		private var attriMediator:D3AttriPopViewMediator;
		
		private function open3dAttri():void
		{
			if(attriView!=null) {
				sendAppNotification(D3Event.open_view3d_event,attriView,DataManager.pop3d_attri.toString())	
				return ;
			}
			
			attriView = new D3AttriPopView();
			attriView.label = DataManager.tabLabel3d_attri;
			sendAppNotification(D3Event.open_view3d_event,attriView,DataManager.pop3d_attri.toString())
			iManager.registerMediator(attriMediator = new D3AttriPopViewMediator(attriView));
		}
		
		private function close3dAttri():void
		{
			sendAppNotification(D3Event.close_view3d_event,attriView,DataManager.pop3d_attri.toString())
		}
		
		///////////////// console ///////////////
		
		private var consoleView:D3ConsolePopView;
		private var consoleMediator:D3ConsolePopViewMediator;
		
		private function open3dConsole():void
		{
			if(consoleView!=null) {
				sendAppNotification(D3Event.open_view3d_event,consoleView,DataManager.pop3d_console.toString())	
				return ;
			}
			
			consoleView = new D3ConsolePopView();
			consoleView.label = DataManager.tabLabel3d_console
			sendAppNotification(D3Event.open_view3d_event,consoleView,DataManager.pop3d_console.toString())
			iManager.registerMediator(consoleMediator = new D3ConsolePopViewMediator(consoleView));
		}
		
		private function close3dConsole():void
		{
			sendAppNotification(D3Event.close_view3d_event,consoleView,DataManager.pop3d_console.toString())
		}
		
		
	}
}