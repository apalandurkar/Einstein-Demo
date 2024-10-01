/*public with sharing class OpportunityInfo {
    @InvocableMethod(label='Get Opportunity Info' description='Returns Opportunity Amount, Description, and Close Date')
    public static List<String> getOpportunityInfo(List<Id> opportunityIds) {
        // List to store the output
        List<String> results = new List<String>();

        // Query Opportunity records for the provided Opportunity Ids
        List<Opportunity> opportunities = [
            SELECT Amount, Description, CloseDate 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ];

        // Loop through the Opportunities and create result strings
        for (Opportunity opp : opportunities) {
            results.add(
                'Opportunity Amount: ' + opp.Amount + 
                ', Description: ' + opp.Description + 
                ', Close Date: ' + opp.CloseDate
            );
        }

        // Handle case when no Opportunities are found
        if (results.isEmpty()) {
            results.add('No Opportunity found for the provided Id(s).');
        }

        return results;
    }
}*/
/*public with sharing class OpportunityInfo {
    
    @InvocableMethod(label='Get Opportunity Info and Estimate' description='Returns Opportunity Amount, Description, Close Date and sends to an external API for estimate calculation')
    public static List<String> getOpportunityEstimate(List<Id> opportunityIds) {
        // List to store the output
        List<String> results = new List<String>();

        // Query Opportunity records for the provided Opportunity Ids
        List<Opportunity> opportunities = [
            SELECT Amount, Description, CloseDate 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ];

        // Loop through the Opportunities and create result strings
        for (Opportunity opp : opportunities) {
            // Construct the Opportunity details string
            String oppDetails = 'Opportunity Amount: ' + opp.Amount + 
                                ', Description: ' + opp.Description + 
                                ', Close Date: ' + opp.CloseDate;

            // Perform the asynchronous callout to external API (future method)
            callExternalApi(opp.Id, opp.Amount, opp.Description, opp.CloseDate);

            // Add the Opportunity details to the results (no estimate returned synchronously)
            results.add(oppDetails + ' - Estimate calculation sent to external API.');
        }

        // Handle case when no Opportunities are found
        if (results.isEmpty()) {
            results.add('No Opportunity found for the provided Id(s).');
        }

        return results;
    }

    // This method performs an HTTP callout to the external API asynchronously
    @future(callout=true)
    public static void callExternalApi(Id oppId, Decimal amount, String description, Date closeDate) {
        try {
            HttpRequest req = new HttpRequest();
            Http http = new Http();

            // Set the endpoint (external API URL) where the data will be sent
            req.setEndpoint('https://external-api.com/calculateEstimate');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            // Construct the body with Opportunity data in JSON format
            String requestBody = JSON.serialize(new Map<String, Object>{
                'oppId' => oppId,
                'amount' => amount,
                'description' => description,
                'closeDate' => closeDate
            });

            req.setBody(requestBody);

            // Perform the callout
            HttpResponse res = http.send(req);

            // Optionally, log the response or store it in a custom field for future reference
            if (res.getStatusCode() == 200) {
                // Log success or store the response in a custom object or field
                System.debug('Estimate API Callout Success: ' + res.getBody());
            } else {
                // Handle the error response from the external API
                System.debug('Estimate API Callout Failed. Status Code: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            // Log the exception
            System.debug('Error during API callout: ' + e.getMessage());
        }
    }
}*/
public with sharing class OpportunityInfo {
    
    @InvocableMethod(label='Get Opportunity Info and Estimate' description='Returns Opportunity Amount, Description, Close Date and sends to an external API for estimate calculation')
    public static List<String> getOpportunityEstimate(List<Id> opportunityIds) {
        // List to store the output
        List<String> results = new List<String>();

        // Query Opportunity records for the provided Opportunity Ids
        List<Opportunity> opportunities = [
            SELECT Amount, Description, CloseDate 
            FROM Opportunity 
            WHERE Id IN :opportunityIds
        ];

        // Loop through the Opportunities and create result strings
        for (Opportunity opp : opportunities) {
            // Construct the Opportunity details string
            String oppDetails = 'Opportunity Amount: ' + opp.Amount + 
                                ', Description: ' + opp.Description + 
                                ', Close Date: ' + opp.CloseDate;

            // Perform the asynchronous callout to external API (future method)
            callExternalApi(opp.Amount, opp.Description, opp.CloseDate, 'testincent68@gmail.com', 'New Account');

            // Add the Opportunity details to the results (no estimate returned synchronously)
            results.add(oppDetails + ' - Estimate calculation sent to external API.');
        }

        // Handle case when no Opportunities are found
        if (results.isEmpty()) {
            results.add('No Opportunity found for the provided Id(s).');
        }

        return results;
    }

    // This method performs an HTTP callout to the external API asynchronously
    @future(callout=true)
public static void callExternalApi(Decimal amount, String description, Date closeDate, String userEmail, String orderType) {
    try {
        HttpRequest req = new HttpRequest();
        Http http = new Http();

        // Set the endpoint (Xactly API URL) where the data will be sent
        req.setEndpoint('https://api.xactlycorp.com/api/estimator/v1/estimation');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer '); // Replace with a valid token
        req.setHeader('Content-Type', 'application/json');

        // Convert the Date to DateTime and format it as needed
        DateTime incentiveDateTime = DateTime.newInstance(closeDate, Time.newInstance(0, 0, 0, 0));
        
        // Construct the body with Opportunity data in JSON format
        String requestBody = JSON.serialize(new List<Map<String, Object>>{
            new Map<String, Object>{
                'amount' => String.valueOf(amount), // Convert Decimal to String
                'amountUnitType' => 'USD',
                'incentiveDate' => incentiveDateTime.format('yyyy-MM-dd HH:mm:ss'), // Format the DateTime
                'orderType' => orderType,
                'userEmail' => userEmail
            }
        });

        req.setBody(requestBody);

        // Perform the callout
        HttpResponse res = http.send(req);

        // Optionally, log the response or store it in a custom field for future reference
        if (res.getStatusCode() == 200) {
            // Log success or store the response in a custom object or field
            System.debug('Estimate API Callout Success: ' + res.getBody());
        } else {
            // Handle the error response from the external API
            System.debug('Estimate API Callout Failed. Status Code: ' + res.getStatusCode() + ' Response: ' + res.getBody());
        }
    } catch (Exception e) {
        // Log the exception
        System.debug('Error during API callout: ' + e.getMessage());
    }
}
}
