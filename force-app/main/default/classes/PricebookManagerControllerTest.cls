@IsTest
private class PricebookManagerControllerTest {

    @IsTest
    static void testGettingAllPricebookEntries() {
        List<PricebookEntry> testPricebookEntries = TestUtils.populatePricebookEntries(true);
        Test.startTest();
        List<PricebookEntry> currentPricebookEntries = PricebookManagerController.getAllPricebookEntries();
        Test.stopTest();
        System.assertEquals(testPricebookEntries.size(), currentPricebookEntries.size(), 'Pricebook entries lists size are not equal.');
    }

    @IsTest
    static void testUpdatingEditedPricebookEntries() {
        List<PricebookEntry> testPricebookEntries = TestUtils.populatePricebookEntries(true);
        for (PricebookEntry pricebookEntry : testPricebookEntries) {
            pricebookEntry.UnitPrice *= Math.round(Math.PI);
        }
        Test.startTest();
        PricebookManagerController.updateEditedPricebookEntries(testPricebookEntries);
        Test.stopTest();
        List<PricebookEntry> currentPricebookEntries = PricebookManagerController.getAllPricebookEntries();
        for (PricebookEntry testPricebookEntry : testPricebookEntries) {
            for (PricebookEntry currentPricebookEntry : currentPricebookEntries) {
                System.assert(testPricebookEntry.UnitPrice == currentPricebookEntry.UnitPrice);
            }
        }
    }
}