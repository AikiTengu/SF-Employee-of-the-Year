public inherited sharing class ContactController {
	@AuraEnabled(cacheable=true)
	public static List<Contact> getContacts() {
		return getFullContactList();
	}

	@AuraEnabled
	public static void setActiveContact(String contactToSelectId) {
		List<Contact> contactList = getActiveContactList();
		for (Contact contact : contactList) {
			contact.Active__c = false;
		}
		try {
			update contactList;
		} catch (DmlException e) {
			throw new DmlException(e.getMessage());
		}
			Contact contact = getContactById(contactToSelectId);
			contact.Active__c = true;
        try {    
			update contact;
		} catch (DmlException e) {
			throw new DmlException(e.getMessage());
		}
	}

	private static List<Contact> getFullContactList() {
		return  [SELECT FirstName, LastName, Email, Department FROM Contact ORDER BY Name];
	}

	private static List<Contact> getActiveContactList() {
		return [SELECT Id FROM Contact WHERE Active__c = TRUE];
	}

	private static Contact getContactById(String Id) {
		return [SELECT Id FROM Contact WHERE Id = :Id];
	}
}
