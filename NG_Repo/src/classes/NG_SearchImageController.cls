/**
 * Created by jeziorem on 05.09.2019.
 */

public with sharing class NG_SearchImageController {
    private static String sanitizeQueryString(String aQuery) {
        if (aQuery == null) return '%';

        String trimmedQuery = aQuery.trim();
        if (trimmedQuery.length() == 0) return '%';
        return '%' + trimmedQuery.replaceAll('\\W+', '%') + '%';
    }
    @AuraEnabled
    public static List<NG_Image_Shelf__c> allImages(String nameFilterString) {
        String composedFilter = sanitizeQueryString(nameFilterString);
        return [SELECT Id, Title__c FROM NG_Image_Shelf__c WHERE Title__c LIKE :composedFilter LIMIT 500];
    }

    @AuraEnabled
    public static void sendEmailToPatient(String emailTo, List<String> listToSend) {
        List<String> titleNames = listToSend;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{emailTo});
        mail.setSenderDisplayName(emailTo);
        mail.setSubject('List of searched NG results for ' + emailTo);
        mail.setPlainTextBody('results:   ' + titleNames);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}