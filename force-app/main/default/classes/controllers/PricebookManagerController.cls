public with sharing class PricebookManagerController {

	@AuraEnabled(Cacheable = true)
	public static List<PricebookEntry> getAllPricebookEntries() {
		return [SELECT Id,
		        Name,
		        ProductCode,
		        UnitPrice,
		        IsActive,
		        Product2Id FROM PricebookEntry];
	}

	@AuraEnabled
	public static void updateEditedPricebookEntries(List<PricebookEntry> pricebookEntries) {
		try {
			update pricebookEntries;
		} catch (DmlException e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

}