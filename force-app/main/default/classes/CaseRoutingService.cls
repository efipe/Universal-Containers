public with sharing class CaseRoutingService {
    
    private static final Map<String, SObjectField> languageToQueueMap = new Map<String,SObjectField>{
        	'English' => Routing_Configuration__mdt.Routing_English__c,
            'German' => Routing_Configuration__mdt.Routing_German__c,
            'Chinese' => Routing_Configuration__mdt.Routing_Chinese__c,
            'French' => Routing_Configuration__mdt.Routing_French__c,
            'Italian' => Routing_Configuration__mdt.Routing_Italian__c,
            'Portuguese' => Routing_Configuration__mdt.Routing_Portuguese__c
    };

    private static CaseRoutingService instance;
    private static Map <String, Group> developerNameMap;
    private static Map <Id, Group> queues;
    
    private CaseRoutingService(){
        developerNameMap = new Map <String,Group>();
        queues = new Map <Id, Group>([SELECT Id, DeveloperName from GROUP where Type = 'Queue']);
        
        for (Group queue : queues.values()){
            developerNameMap.put(queue.DeveloperName, queue);
        }
        System.debug(developerNameMap);
        System.debug(queues);
    }
    
    public static CaseRoutingService getInstance(){
        if(instance == null){
           instance = new CaseRoutingService();
        }
        return instance;
    }
    
    public Id getQueueForCase(Case incomingCase){
        
        if (!queues.containsKey((String) incomingCase.OwnerId)){
            System.debug('incomingCase Owner id is null');
        return null;
        }
        
       Routing_Configuration__mdt metadataConfig = CaseRoutingConfiguration.getInstance().getRoutingData(queues.get(incomingCase.OwnerId).DeveloperName);
       System.debug(metadataConfig);
        
       
        if (!(metadataConfig == null)){
            SObjectField languageToGet = languageToQueueMap.get(incomingCase.Preferred_Language__c);
            System.debug(incomingCase.Preferred_language__c);
            String config = (String) metadataConfig.get(languageToGet);
            Group routedQueue = developerNameMap.get(config);
            return routedQueue != null ? routedQueue.Id : null;
        }
       
        return null;
    }

    public Id getDefaultQueue(Case incomingCase){
        Routing_Configuration__mdt metadataConfig = CaseRoutingConfiguration.getInstance().getRoutingData(queues.get(incomingCase.OwnerId).DeveloperName);
        return null;
    }
   
}