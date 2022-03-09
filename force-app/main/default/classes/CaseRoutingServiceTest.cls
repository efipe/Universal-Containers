
@IsTest
private class CaseRoutingServiceTest{

    @TestSetup static void setup(){

        Group queue = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Payment_Dept'];
        RecordType recordType = [SELECT Id, Name FROM RecordType where Name = 'Invoice Request'];
        Case newTestCase = new Case();
        newTestCase.OwnerId = queue.Id;
        newTestCase.Preferred_Language__c = LanguageEnum.English.name();
        newTestCase.RecordTypeId = recordType.Id;
        insert newTestCase;
    }

    @isTest static void shouldGetCorrectQueueForCaseGivenExistingCaseId(){

        Group queue = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName = 'English_Payment'];
        Case newTestCase = [SELECT Id, OwnerId, Preferred_Language__c FROM Case];
        Id getQueueId = CaseRoutingService.getInstance().getQueueForCase(newTestCase);
        System.assertEquals(queue.Id, getQueueId);
    }

    @IsTest static void shouldReturnNullGivenNotExistingLanguage(){

        User user = [SELECT Id, Name FROM User Where Name = 'Integration User'];
        Case newTestCase = [SELECT Id, OwnerId,Preferred_Language__c FROM Case];
        newTestCase.OwnerId = User.Id;
        Id getQueueId = CaseRoutingService.getInstance().getQueueForCase(newTestCase);
        System.assertEquals(null, getQueueId);
    }
}