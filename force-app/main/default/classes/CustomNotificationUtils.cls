/**
 * @description       : 
 * @author            : Agustín Ayala
 * @group             : 
 * @last modified on  : 29-08-2022
 * @last modified by  : Agustín Ayala
**/
public with sharing class CustomNotificationUtils 
{
    // DEIXEI O MÉTODO GENÉRICO PARA QUE POSSA SER USADO EM OUTRAS OCASIÕES
    public static void notify(String notificationDeveloperName, Set<String> recipientsIds, String targetId, String titleMessage, String bodyMessage) 
    {

        // Get the Id for our custom notification type
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName =: notificationDeveloperName];

        // DEIXO PARA TUA DIVERSÃO ACHAR UMA FORMA DE VERIFICART SE
        // O CUSTOM NOTIFICATION TYPE EXISTE E SE NÃO EXISTE DEVOLVER
        // UM ERRO PARA A CLASSE CONSUMIDORA
        
        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        // DEIXEI O BODY E TÍTULOS GENÉRICOS PORQUE NÃO É POSSÍVEL BULKIFICAR O NOTIFICATION
        // SE QUISER ALGO MAIS PERSONALIZADO RECOMENDO USAR O DISPARO DE EMAIL USANDO APEX
        notification.setBody(bodyMessage);
        notification.setTitle(titleMessage);
        //notification.setTitle('Apex Custom Notification');
        //notification.setBody(name+', we are going to have a great client!');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        // Actually send the notification
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}
