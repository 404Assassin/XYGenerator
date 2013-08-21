////////////////////////////////////////////////////////////////////////////////
//  Copyright 2012 GP Strategies
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////
package com.cw.model.regularExpression {

	/**
	 * :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 * class description: StripQuotes
	 * language version: ActionScript 3.0
	 * author: cworley
	 * created: May 21, 2012
	 * TODO:
	 * :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	public class StripQuotes {
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Variables
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Public Interfaces
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		public function StripQuotes(){};
		/**
		 * replace @param stringReference with same string sans quotes-
		 * @return string sans quotes-
		 */		
		public function stripTheQuotes (stringReference:String):String {
			var stringReplacePattern:RegExp = /"|'|“|”|‘|’/g;
			return stringReference.replace(stringReplacePattern, "");
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Methods
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	}
}