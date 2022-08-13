public class SendNotification {
    public static void send(){
        Set<String> ids = new Set<String>();
        String idCoisa = UserInfo.getUserId();
        ids.add(idCoisa);
        
        //List<Account> listaOtaCoisa = new List<Account>();
        //listaOtaCoisa.add([SELECT Id FROM Account WHERE Name='Burlington Textiles Corp of America']);
        //String idOtaCoisa = String.valueOf(ListaOtaCoisa[0]);
        //System.debug(idOtaCoisa);
        CustomNotificationApexTest.notifyUsers(ids, '0018Z00002hkcywQAA', 'Yan');
    }
}