@isTest
    private class ClientPotentialNotificationTest {
        
        @TestSetup static void makeData(){
            
            // Opportunity opp1 = new Opportunity();
            
            // opp1.Name = 'opp1';
            // opp1.CloseDate = Date.Today();
            // opp1.StageName = 'Negotiation/Review';
            // opp1.Amount = 5000;
            
            // Insert opp1;
            
        }

        @isTest static void updateTopClientAndNotify_Amount1to10k_Test(){                         
            
            Opportunity opp = new Opportunity();
            
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 5000;
            
            Insert opp;

            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, 'Good');
        }
        
        @isTest static void updateTopClientAndNotify_Amount10kto100k_Test(){

            Opportunity opp = new Opportunity();
             
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 50000;
            
            Insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, 'Very Good');
        }          
        
        @isTest static void updateTopClientAndNotify_Amount100kAbove_Test(){

            Opportunity opp = new Opportunity();
            
            Test.startTest();
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 500000;
            
            Insert opp;
            Test.stopTest();
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, 'Excellent');
        }        

        @isTest static void updateTopClientAndNotify_AmountNull_Test(){

            Opportunity opp = new Opportunity();
             
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = null;
            
            Insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, null);
        }     

        @isTest static void updateTopClientAndNotify_NotifZeroFieldsOk_Test(){
            
            Opportunity opp = new Opportunity();
            
            opp.Name = 'teste 0';
            opp.CloseDate = Date.Today();
            opp.Type = 'Existing Customer - Upgrade';
            opp.StageName = 'Prospecting';
            opp.Amount = 50;
            
            insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 0'];
            
            Boolean NotifReturn = ClientPotentialNotification.updateTopClientAndNotify(listOpp);
            System.AssertEquals(false, NotifReturn);
        }
                
        @isTest static void updateTopClientAndNotify_NotifOneFieldOk_Test(){
            
            Opportunity opp = new Opportunity();

            opp.Name = 'teste 1';
            opp.CloseDate = Date.Today();
            opp.Type = 'New Customer';
            opp.StageName = 'Prospecting';
            opp.Amount = 50;
            
            insert opp;

            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 1'];
            
            Boolean NotifReturn = ClientPotentialNotification.updateTopClientAndNotify(listOpp);
            System.AssertEquals(false, NotifReturn);
        }
        
        @isTest static void updateTopClientAndNotify_NotifTwoFieldsOk_Test(){
            
            Opportunity opp = new Opportunity();
            
            opp.Name = 'teste 2';
            opp.CloseDate = Date.Today();
            opp.Type = 'New Customer';
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 50;
            
            insert opp;

            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 2'];
            
            Boolean NotifReturn = null;
            NotifReturn = ClientPotentialNotification.updateTopClientAndNotify(listOpp);
            System.AssertEquals(false, NotifReturn);
        }

        @isTest static void updateTopClientAndNotify_NotifThreeFieldsOk_Test(){
    
            Opportunity opp = new Opportunity();
    
            opp.Name = 'teste 3';
            opp.CloseDate = Date.Today();
            opp.Type = 'New Customer';
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 500000;
    
            insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 3'];
            
            Boolean NotifReturn = null;
            NotifReturn = ClientPotentialNotification.updateTopClientAndNotify(listOpp);
            System.AssertEquals(true, NotifReturn);    
        }

        @isTest static void updateTopClientAndNotify_sendNotification_Test(){

            Opportunity opp = new Opportunity();
    
            // opp.OwnerId = '0058Z000008rKiOQAU';
            // opp.Id = '0068Z00001Z5VVQQA3';
            // opp.Owner.Name = 'Vitor de Carvalho';
            
            Try{
                ClientPotentialNotification.sendNotification('0058Z000008rKiOQAU', '0068Z00001Z5VVQQA3', 'Vitor de Carvalho');
            } catch (Exception e){
                System.debug('Erro ao enviar a notificação: ' + e.getMessage());
            }
        }
    }