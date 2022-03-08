public with sharing class CaseRoutingService {
    
    
    private static final Map<String, SObjectField> languageToQueueMap = new Map<String,SObjectField>{
        	'English' => Routing_Configuration__mdt.Routing_English__c,
            'German' => Routing_Configuration__mdt.Routing_German__c,
            'Chinese' => Routing_Configuration__mdt.Routing_Chinese__c,
            'French' => Routing_Configuration__mdt.Routing_French__c,
            'Italian' => Routing_Configuration__mdt.Routing_Italian__c,
            'Portuguese' => Routing_Configuration__mdt.Routing_Portuguese__c
    };
    // static instance of the class
    private static CaseRoutingService instance;
    private static Map <Id, Group> developerNameMap;
    private static Map <Id, Group> queues;
    
    // private constructor to avoid creating instance outside of this class
    private CaseRoutingService(){
        developerNameMap = new Map <Id,Group>();
        queues = new Map <Id, Group>([SELECT Id, DeveloperName from GROUP where Type = 'Queue']);
        
        // Store queues
        for (Id queueId : queues.keySet()){
            developerNameMap.put(queueId, queues.get(queueId));
        }
    }
    
    // getter for the instance
    public static CaseRoutingService getInstance(){
        if(instance == null){
           instance = new CaseRoutingService();
        }
        return instance;
    }
    
    
    // method to get appropiate Queue
    public Id getQueueForCase(Case incomingCase){
        
        if (!queues.containsKey((String) incomingCase.OwnerId)) {
            return null;
        }
        
       Routing_Configuration__mdt metadataConfig = CaseRoutingConfiguration.getInstance().getRoutingData(queues.get((String) incomingCase.OwnerId ).DeveloperName);
        
       
        if (metadataConfig == null){
            SObjectField languageToGet = languageToQueueMap.get(incomingCase.Preferred_Language__c);
            String config = (String) metadataConfig.get(languageToGet);
            Group routedQueue = developerNameMap.get(config);
            
            return routedQueue != null ? routedQueue.Id : null;
        }
       
        return null;
    }
   
}