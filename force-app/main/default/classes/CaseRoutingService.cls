public with sharing class CaseRoutingService {
    
    private static final Map<LanguageEnum, SObjectField> languageToQueueMap = new Map<LanguageEnum,SObjectField>{
        	LanguageEnum.English => Routing_Configuration__mdt.Routing_English__c,
            LanguageEnum.German => Routing_Configuration__mdt.Routing_German__c,
            LanguageEnum.Chinese => Routing_Configuration__mdt.Routing_Chinese__c,
            LanguageEnum.French => Routing_Configuration__mdt.Routing_French__c,
            LanguageEnum.Italian => Routing_Configuration__mdt.Routing_Italian__c,
            LanguageEnum.Portuguese => Routing_Configuration__mdt.Routing_Portuguese__c
    };

    private static CaseRoutingService instance;
    private static Map <String, Group> queueByDeveloperName;
    private static Map <Id, Group> queue;

    public String getQueueDispatcherName(Id languageBasedQueueName, LanguageEnum queueLanguage){
        String languageBasedQueueNameToString = queue.get(languageBasedQueueName).DeveloperName;
        System.debug(languageBasedQueueNameToString);


        for (Routing_Configuration__mdt routing : CaseRoutingConfiguration.getInstance().getAllRoutingConfig()) {
            SObjectField routingFieldBasedOnLanguage = languageToQueueMap.get(queueLanguage);
            System.debug(routingFieldBasedOnLanguage);
            if (routingFieldBasedOnLanguage != null && routing.get(routingFieldBasedOnLanguage) == languageBasedQueueNameToString) {
                return routing.Queue_Dispatcher__c;
            }
        }
        return null;
    }

    public Id getDefaultQueue(String languageBasedQueueName, LanguageEnum queueLanguage){
        String routing = getQueueDispatcherName(languageBasedQueueName, queueLanguage);
        Group defaultQueue = queueByDeveloperName.get(routing);
        return defaultQueue != null ? defaultQueue.Id : null;
    }
    
    public Id getQueueForCase(Case incomingCase){    
        if (!queue.containsKey((String) incomingCase.OwnerId)){
            System.debug('incomingCase Owner id is null');
        return null;
        }
        
       Routing_Configuration__mdt metadataConfig = CaseRoutingConfiguration.getInstance().getRoutingData(queue.get(incomingCase.OwnerId).DeveloperName);
        
        if (!(metadataConfig == null)){
            SObjectField languageToGet = languageToQueueMap.get(LanguageEnum.valueOf(incomingCase.Preferred_Language__c));
            String routing = (String) metadataConfig.get(languageToGet);
            Group routedQueue = queueByDeveloperName.get(routing);
            return routedQueue != null ? routedQueue.Id : null;
        }
        return null;
    }

    public static CaseRoutingService getInstance(){
        if(instance == null){
           instance = new CaseRoutingService();
        }
        return instance;
    }

    private CaseRoutingService(){
        queueByDeveloperName = new Map <String,Group>();
        queue = new Map <Id, Group>([SELECT Id, DeveloperName from GROUP where Type = 'Queue']);
        for (Group queue : queue.values()){
            queueByDeveloperName.put(queue.DeveloperName, queue);
        }
    }
}