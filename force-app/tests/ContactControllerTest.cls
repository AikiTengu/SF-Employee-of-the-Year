@isTest
private class ContactControllerTest {
    private static final Integer CONTACTS_NUMBER = 20;
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(CONTACTS_NUMBER);
	}

	@isTest
	static void TestGettingAllContacts() {
        List<Contact> testContacts = ContactController.getContacts();

        System.assertEquals(testContacts.size(), CONTACTS_NUMBER);
    }

    @isTest
	static void TestGettingActiveContact() {
        Contact activeContact = ContactController.getActiveContact();

        System.assertEquals(activeContact.FirstName, 'Active');
        System.assertEquals(activeContact.LastName, 'Contact');
    }

    @isTest
	static void TestSettingActiveContact() {
        List<Contact> testContacts = ContactController.getContacts(); 

        Test.startTest();
        ContactController.setActiveContact(testContacts.get(0).Id);
        Test.stopTest();

        Contact activeContactAfterChange = ContactController.getActiveContact();

        System.assertEquals(activeContactAfterChange.Id, testContacts.get(0).Id);

    }
}