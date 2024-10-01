public with sharing class EstimateCalculator {

    @InvocableMethod(label='Calculate Estimate' description='Sends Opportunity data to external API and returns estimate')
    public static List<String> calculateEstimate(List<OpportunityData> opportunityDataList) {
        List<String> results = new List<String>();

        // Loop through the provided Opportunity data
        for (OpportunityData data : opportunityDataList) {
            try {
                HttpRequest req = new HttpRequest();
                Http http = new Http();

                // Set the endpoint (Xactly API URL)
                req.setEndpoint('https://api.xactlycorp.com/api/estimator/v1/estimation');
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer WSLivHKITwkdNoc8jIGLi6rISyBK6h55'); // Replace with a valid token
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Cookie', 'xreferer=xactly');

                // Convert the Date to DateTime
                DateTime incentiveDateTime = DateTime.newInstance(data.closeDate, Time.newInstance(0, 0, 0, 0));

                // Construct request body
               /*   String requestBody = JSON.serialize(new Map<String, Object>{
                    'amount' => '2000.00', 
                   // 'amount' => String.valueOf(data.amount),// Convert Decimal to String
                    'amountUnitType' => 'USD',
                    //'incentiveDate' => incentiveDateTime.format('yyyy-MM-dd HH:mm:ss'),
                    'incentiveDate' =>'2023-08-02 00:00:00',
                    'orderType' => 'New Account',
                    'userEmail' => 'xactly5@rediffmail.com'
                    
                });*/
                          /*  String requestBody = '[{'+
                                                    '"amount":"2000.00",'+
                                                    '"amountUnitType":"USD",'+
                                                    '"incentiveDate":"2023-08-02 00:00:00",'+
                                                    '"orderType":"New Account",'+
                                                    '"userEmail":"xactly5@rediffmail.com"'+
                                                '}]';*/
                         String requestBody = '[{' +
                                                    '"amount":"' + data.amount + '",' + // Fetching opportunity amount
                                                    '"amountUnitType":"USD",' + 
                                                    '"incentiveDate":"' + DateTime.newInstance(data.closeDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd HH:mm:ss') + '",' + // Fetching opportunity close date
                                                    '"orderType":"New Account",' + 
                                                    '"userEmail":"xactly5@rediffmail.com"' +
                                                '}]';
                                                
                req.setBody(requestBody);

                // Perform the callout
                HttpResponse res = http.send(req);

                // Parse the API response if the status is 200
                if (res.getStatusCode() == 200) {
                    // Assuming the API returns a JSON response with the estimate
                  /*  Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    String estimateValue = (String) responseMap.get('estimate'); // Adjust according to the actual API response

                    // Add the estimate to the results
                    results.add('Estimate for Opportunity ID ' + data.opportunityId + ' is: ' + estimateValue);*/
                    // Assuming the API returns a JSON response with the estimate
                    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                    // Extract values from the response
                    List<Object> resultsList = (List<Object>) responseMap.get('results');
                    Map<String, Object> orderDetails = (Map<String, Object>) ((Map<String, Object>) resultsList[0]).get('order');
                    Map<String, Object> estimateDetails = (Map<String, Object>) ((Map<String, Object>) resultsList[0]).get('estimate');

                    // Prepare the response string
                    String estimateString = 'Estimate for Opportunity ID ' + data.opportunityId + ': ' +
                        'Total Orders: ' + responseMap.get('totalOrders') + ', ' +
                        'Total Commissions: ' + responseMap.get('totalCommissions') + ', ' +
                        'Total Bonus: ' + responseMap.get('totalBonus') + ', ' +
                        'Current Commission: ' + responseMap.get('currentCommission') + ', ' +
                        'Estimated Commission: ' + estimateDetails.get('commissionAmount') + ', ' +
                        'Bonus Amount: ' + estimateDetails.get('bonusAmount') + ', ' +
                        'Incentive Date: ' + orderDetails.get('incentiveDate') + ', ' +
                        'Order Type: ' + orderDetails.get('orderType');

                    // Add the formatted result to the list
                    results.add(estimateString);
                } else {
                    // Handle non-200 responses
                    results.add('Failed to retrieve estimate. Status Code: ' + res.getStatusCode());
                }
            } catch (Exception e) {
                results.add('Error during API callout: ' + e.getMessage());
            }
        }

        return results;
    }

    public class OpportunityData {
        @InvocableVariable(label='Opportunity Id' description='Opportunity Id')
        public Id opportunityId;

        @InvocableVariable(label='Amount' description='Opportunity Amount')
        public Decimal amount;

        @InvocableVariable(label='Description' description='Opportunity Description')
        public String description;

        @InvocableVariable(label='Close Date' description='Opportunity Close Date')
        public Date closeDate;
    }
}