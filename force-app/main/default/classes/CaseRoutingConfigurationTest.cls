@IsTest
private class CaseRoutingConfigurationTest{

    @IsTest static void shouldGetCorrectConfigurationGivenExitingQueueDispatcher(){
        String queueDispatcherName = 'Payment_Dept';
        Routing_Configuration__mdt expectedRouting = [
                SELECT Id
                FROM Routing_Configuration__mdt
                WHERE Queue_Dispatcher__c = :queueDispatcherName
        ];
        Routing_Configuration__mdt routing = CaseRoutingConfiguration.getInstance().getRoutingData(queueDispatcherName);
        System.assertEquals(expectedRouting.Id, routing.Id);
    }

    @IsTest static void shouldReturnNullGivenNotExitingQueueDispatcher(){
        Routing_Configuration__mdt routing = CaseRoutingConfiguration.getInstance().getRoutingData('Polish_Payment_Dept');
        System.assertEquals(null, routing);
    }
}