package com.cw.model.regularExpression {
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Class characteristics
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	public class ImageFileCheck {
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Constructor
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function ImageFileCheck () {}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Public Interfaces
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function checkImageFile (fileReference:String):Boolean {
			var imageFilePattern:RegExp = /(?i)\.(jpg|png|gif|jpeg)$/;
			return imageFilePattern.test(fileReference);
			if(fileReference.match(imageFilePattern) == null) {
				return false;
			} else {
				return true;
			}
		}
	}
}
