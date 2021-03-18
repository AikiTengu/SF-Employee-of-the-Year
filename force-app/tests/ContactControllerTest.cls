@isTest
private class ContactControllerTest {
    private static final Integer CONTACTS_NUMBER = 20;
	@testSetup
	static void makeData() {
		List<Contact> testContacts = CandidateInNominationTestFactory.createContacts(CONTACTS_NUMBER);
	}

	@isTest
	static void TestGettingAllContacts() {
        List<Contact> testContacts = [SELECT Id, FirstName, LastName FROM Contact];
    }

    @isTest
	static void TestGettingActiveContact() {
    }

    @isTest
	static void TestSettingActiveContact() {
    }
}