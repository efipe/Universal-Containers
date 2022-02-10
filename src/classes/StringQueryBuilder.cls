/**
 * Created by POTERFI on 2/10/2022.
 */

public with sharing class StringQueryBuilder {


    public String generatedQuery;

    public String baseQuery = 'Select Id, Name, Route__r.Name, Vessel__r.Name, Departure_date__c, Arrival_date__c, Route__r.Port_of_Origin__c, Route__r.Port_of_Destination__c FROM Schedule__c';

    public String whereConditioner = ' Where ';

    public String buildQuery(Date departureDate, Date arrivalDate, String departurePort, String arrivalPort) {

        if ( ) {
            generatedQuery = baseQuery + whereConditioner + 'Departure_date__c in ' + '('+ departureDate + ')';
        }

        return generatedQuery;
    }


}