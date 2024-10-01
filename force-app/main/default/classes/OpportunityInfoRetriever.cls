public with sharing class OpportunityInfoRetriever {

    @InvocableMethod(label='Fetch Opportunity Data' description='Fetches Opportunity Amount, Description, Close Date')
    public static List<String> fetchOpportunityData(List<Id> opportunityIds) {
        List<String> results = new List<String>();

        // Query Opportunity records
        List<Opportunity> opportunities = [
            SELECT Amount, Description, CloseDate 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ];

        // Loop through Opportunities and add details to the results
        for (Opportunity opp : opportunities) {
            String oppDetails = 'Opportunity Amount: ' + opp.Amount + 
                                ', Description: ' + opp.Description + 
                                ', Close Date: ' + opp.CloseDate;
            results.add(oppDetails);
        }

        // Handle case when no Opportunities are found
        if (results.isEmpty()) {
            results.add('No Opportunity found for the provided Id(s).');
        }

        return results;
    }
}