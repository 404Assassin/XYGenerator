////////////////////////////////////////////////////////////////////////////////
//  Copyright 2012 GP Strategies
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////
package com.cw.view.forms {
	/**
	 * :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 * class description: FileInput
	 * language version: ActionScript 3.0
	 * author: cworley
	 * created: Apr 13, 2012
	 * TODO:
	 * :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	import com.cw.control.observer.ISubject;
	import com.cw.control.observer.InvokedObserver;
	import com.cw.model.regularExpression.ImageFileCheck;
	import com.cw.model.regularExpression.StripQuotes;
	import com.cw.view.shapeCreators.CreateShape;
	import com.cw.view.text.CDynamicTextField;
	import com.cw.view.text.CInputTextField;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class FileInput implements ISubject {
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Variables
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private var observer:ISubject;
		private var contactFormHolder:Sprite;
		private var theFormHolder:Sprite;
		private var theCDynamicTextField:Object = new CDynamicTextField();
		private var theSubmitButton:Sprite;
		private var urlValidationBoolean:Boolean;
		private var urlInputBoolean:Boolean;
		private var defaultURLText:String = 'enter an image URL';
		private var urlErrorPopUp:Object;
		private var urlData:String;
		private var inputTextField:TextField;
		private var imageReference:String;
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Public Interfaces
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 * InvokedObserver interface, reference update, and subscription with
		 * updated observer and adding subscription with addObserver(this).
		 */
		public function addObserver (observer:ISubject):void {
			this.observer = observer;
			observer.addObserver(this);
		}
		/**
		 * InvokedObserver notification
		 */
		public function notifyObservers (infoObject:String):void {
			observer.notifyObservers(infoObject);
		}
		/**
		 * remove an observer refrence from InvokedObserver
		 */
		public function removeObserver (observer:ISubject):void {}
		/**
		 * setup the input form
		 */
		public function setInputForm ():void {
			initBuild();
		}
		public function getInputForm ():Sprite {
			return theFormHolder;
		}
		public function getImageReference ():String {
			return imageReference;
		}
		public function update (infoObject:String):void {
			if(hasOwnProperty(infoObject)) {
				this[infoObject]();
			}
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Methods
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function initBuild ():void {
			theFormHolder = new Sprite();
			addFormHolder();
		}
		private function addFormHolder ():void {
			contactFormHolder = new Sprite();
			TweenMax.to(contactFormHolder, 0, {alpha:0, x:0, y:0});
			theFormHolder.addChild(contactFormHolder);
			addFormHolderBackground();
		}
		private function addFormHolderBackground ():void {
//			var contactFormBackgroundHolder:Sprite = new Sprite();
//			var theShapeCreator:CreateShape = new CreateShape();
//			theShapeCreator.draw(CreateShape.SQUARE_FILLED, contactFormBackgroundHolder, 0, 0, 300, 20)
//			TweenMax.to(contactFormBackgroundHolder, 0, {alpha:.5, tint:0x000000});
//			contactFormHolder.addChild(contactFormBackgroundHolder);
			theInputField();
			submitButton();
			initBooleanStates();
		}
		private function initBooleanStates ():void {
			urlInputBoolean = false;
			urlValidationBoolean = false;
		}
		private function theInputField ():void {
			var urlInputField:CInputTextField = new CInputTextField();
			urlInputField.createInputTextFieldInterface(0, 0, 778, 20);
			inputTextField = urlInputField.getInputTextField();
			inputTextField.multiline = false;
			inputTextField.wordWrap = false;
			inputTextField.text = defaultURLText;
			contactFormHolder.addChild(inputTextField);
			inputTextField.addEventListener(FocusEvent.FOCUS_IN, focusInput);
			inputTextField.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			inputTextField.addEventListener(KeyboardEvent.KEY_DOWN, enterKeyHandler);
		}
		private function submitButton ():void {
			var labelContents:String = "<button>submit</button>";
			theCDynamicTextField.textFieldInterface(labelContents, 100, 20, true, 0x000000, false, false, false);
			var theTextField:Sprite = theCDynamicTextField.getTheTextField();
			theSubmitButton = new Sprite();
			theSubmitButton.addEventListener(MouseEvent.MOUSE_UP, buttonInput);
			theSubmitButton.addChild(theTextField);
			theSubmitButton.alpha = 0;
			theFormHolder.addChild(theSubmitButton);
			theSubmitButton.buttonMode = true;
			theSubmitButton.mouseChildren = false;
			TweenMax.to(theSubmitButton, 5, {alpha:0});
			formBuild();
		}
		private function formBuild ():void {
			TweenMax.to(contactFormHolder, .75, {alpha:1 /*, x:0, y:0*/});
			TweenMax.to(theSubmitButton, .75, {alpha:1, x:contactFormHolder.x + contactFormHolder.width + 10, y:contactFormHolder.y});
		}
		private function buttonInput (event:MouseEvent):void {
			urlSubmit(urlData);
		}
		private function enterKeyHandler (event:KeyboardEvent):void {
			urlData = inputTextField.text;
			urlInputBoolean = true;
			if(event.charCode == 13) {
				urlSubmit(urlData);
			}
		}
		private function focusInput (event:FocusEvent):void {
//			if(inputTextField.text.length != 0){
//				trace(inputTextField.text.split("").join(""));
//			}
			if(inputTextField.text == defaultURLText) {
				inputTextField.text = '';
				urlInputBoolean = false;
				return;
			} else if((inputTextField.text.length != 0) && (inputTextField.text != defaultURLText)) {
				inputTextField.text = '';
				urlInputBoolean = false;
			}
		}
		private function focusOut (event:FocusEvent):void {
			if(inputTextField.text.length == 0) {
				inputTextField.text = defaultURLText;
				urlInputBoolean = false;
			}
			urlData = inputTextField.text;
			urlInputBoolean = true;
		}
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Check form validity on send, if invalid display errors
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function urlSubmit (urlData:String):void {
			var theImageFileCheck:ImageFileCheck = new ImageFileCheck();
			var stripQuotes:StripQuotes = new StripQuotes();
			var newURLData:String = stripQuotes.stripTheQuotes(urlData);
			theImageFileCheck.checkImageFile(newURLData);
			if(!theImageFileCheck.checkImageFile(newURLData)) {
				trace(" ::::::::::: FileInput.urlSubmit(urlData) ValidationError", newURLData);
			}
			if(theImageFileCheck.checkImageFile(newURLData) == true) {
				if(urlInputBoolean) {
					setImageRef(newURLData);
				}
			}
		}
		private function setImageRef (urlData:String):void {
			imageReference = urlData
			notifyObservers(imageReference);
		}
	}
}
