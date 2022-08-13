public class SendNotification {
    public static void Send(){
        List<User> recipients = [SELECT Id FROM User];
        Set<String> recipientIds = new Set<String>();        
        String targetId = '0018Z00002hkcywQAA';
        
        for (integer i = 0; i < recipients.size(); i++){
            recipientIds.add(String.ValueOf(recipients[i].Id));   
        }

        CustomNotificationApexTest.notifyUsers(recipientIds, targetId, String.ValueOf(UserInfo.getName()));
    }
}