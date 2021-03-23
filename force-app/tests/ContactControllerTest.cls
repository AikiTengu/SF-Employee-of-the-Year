@isTest
private class ContactControllerTest {
	private static final Integer CONTACTS_NUMBER = 20;
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(CONTACTS_NUMBER);
	}

	@isTest
	static void testGettingAllContacts() {
		List<Contact> testContacts = ContactController.getContacts();

		System.assertEquals(CONTACTS_NUMBER, testContacts.size());
	}

	@isTest
	static void testGettingActiveContact() {
		Contact activeContact = ContactController.getActiveContact();

		System.assertEquals('Active', activeContact.FirstName);
		System.assertEquals('Contact', activeContact.LastName);
	}

	@isTest
	static void testSettingActiveContact() {
		List<Contact> testContacts = ContactController.getContacts();

		Test.startTest();
		ContactController.setActiveContact(testContacts.get(0).Id);
		Test.stopTest();

		Contact activeContactAfterChange = ContactController.getActiveContact();

		System.assertEquals(testContacts.get(0).Id, activeContactAfterChange.Id);
	}
}
