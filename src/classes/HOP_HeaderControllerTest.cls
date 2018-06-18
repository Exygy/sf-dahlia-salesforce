// *****************************************************************************
// CLASS: HOP_HeaderControllerTest
// *****************************************************************************
//
// Author: Vertiba
// Date: 03/18
// Description: Test class for the HOP_HeaderController class.
//
// *****************************************************************************

@isTest
private class HOP_HeaderControllerTest {

	@isTest
	static void headerControllerTest() {
		Test.startTest();

				System.assert(HOP_HeaderController.sfInstanceURL != null);
				System.assert(HOP_HeaderController.seeBackButton == true);
			

		Test.stopTest();
	}

}