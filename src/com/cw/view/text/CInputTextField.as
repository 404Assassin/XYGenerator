package com.cw.view.text{
	/**
	 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 * Class CInputTextField
	 * language version: ActionScript 3.0
	 * player version: Flash 10.0
	 * author: Christian Worley
	 * created: 10/2011
	 * TODO:
	 * ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Imports
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Class characteristics
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	public class CInputTextField{
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Variables
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private var theInputTextField:TextField;
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Constructor
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function CInputTextField(){}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Custom input textfield interface
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function createInputTextFieldInterface(x:Number, y:Number, width:Number, height:Number):void {
			createCustomTextField(x, y, width, height);
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Custom input textfield interface
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function getInputTextField():TextField {
			return theInputTextField;
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Create custom input textfield
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function createCustomTextField(x:Number, y:Number, width:Number, height:Number):void {
			theInputTextField = new TextField();
			theInputTextField.x = x;
			theInputTextField.y = y;
			theInputTextField.width = width;
			theInputTextField.height = height;
			theInputTextField.background = true;
			theInputTextField.border = false;
			theInputTextField.selectable = true;
			theInputTextField.type = TextFieldType.INPUT;
			theInputTextField.defaultTextFormat = formFormat();
			theInputTextField.gridFitType = GridFitType.SUBPIXEL;
			theInputTextField.antiAliasType=AntiAliasType.ADVANCED;
			theInputTextField.sharpness=400;
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Create the custom format
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function formFormat():TextFormat {
			var theFormat:TextFormat = new TextFormat();
			theFormat.align = TextFormatAlign.LEFT;
			theFormat.font = "Trebuchet MS";
			theFormat.color = 0x000000;
			theFormat.size = 12;
			return theFormat;
		}
	}
}