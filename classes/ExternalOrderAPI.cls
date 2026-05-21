@RestResource(urlMapping='/external/orders')
global with sharing class ExternalOrderAPI {

    @HttpPost
    global static String receiveOrder() {

        RestRequest req = RestContext.request;
        
        String body = req.requestBody.toString();

        OrderDTO dto = (OrderDTO) JSON.deserialize(body, OrderDTO.class);

        External_Order__c order = new External_Order__c(
            Order_Number__c = dto.orderNumber,
            Customer_Email__c = dto.customerEmail,
            Order_Amount__c = dto.orderAmount,
            Order_Status__c = dto.orderStatus,
            Order_Date__c = Date.valueOf(dto.orderDate)
        );

        upsert order Order_Number__c;

        return 'SUCCESS';
    }

    global class OrderDTO {
        public String orderNumber;
        public String customerEmail;
        public Decimal orderAmount;
        public String orderStatus;
        public String orderDate;
    }
}