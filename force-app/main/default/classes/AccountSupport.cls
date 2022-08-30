/**
 * @description       : 
 * @author            : Agustín Ayala
 * @group             : 
 * @last modified on  : 29-08-2022
 * @last modified by  : Agustín Ayala
**/
public with sharing class AccountSupport 
{
    public static void updateAccountTopClient(List<Opportunity> lstOpp, Map<Id,Opportunity> mapOldValues)
    {
        Opportunity oldOpp = null;
        
        //VERIFICO AS OPORTUNIDADES EM SEU ESTADO DE DADOS ATUAL CONTRA OS DADOS ANTIGOS
        for(Opportunity oppItem : lstOpp)
        {  
            //SE O MEU MAP É NULO, ENTÃO SEI QUE ESTOU INSERINDO
            if(mapOldValues == null)
            {
                oppItem.TopClient__c = setTopClient(oppItem.Amount);
                //ADICIONO A OPORTUNIDADE EM QUESTÃO 
            }
            // O MAP OLD NÃO ESTÁ NULO, ENTÃO SEI QUE ESTOU LIDANDO COM UMA ALTERAÇÃO
            else 
            {
                // PEGO A OPORTUNIDADE COM OS VALORES ANTIGOS ATRAVÉS DO MAP USANDO
                // O ID DA OPP COMO CHAVE
                oldOpp = mapOldValues.get(oppItem.Id);

                // SE O AMOUNT NÃO FOI ALTERADO, NÃO FAÇO NADA E VOU PARA A PRÓXIMA OPP
                if(oldOpp.Amount == oppItem.Amount)
                    continue;

                //AGORA, SE O AMOUNT FOI ALTERADO, AÍ SIM CHECO O TIPO DE CLIENTE QUE É
                oppItem.TopClient__c = setTopClient(oppItem.Amount);
            }
        }
    }

    //MÉTODO PARA NOTIFICAR USUÁRIOS CASO O AMOUNT, FASE OU TIPO DE OPORTUNIDADE TENHA MUDADO
    public static void notifyOpportunityChangesOnNegotiation(List<Opportunity> lstOpp, Map<Id,Opportunity> mapOldValues)
    {
        Opportunity oldOpp = null;
        List<Opportunity> lstOppNotify = new List<Opportunity>();

        // DEVER DE CASA: ENTENDER A DIFERENÇA ENTRE SET E LIST
        Set<String> setUsersToNotify = new Set<String>();
        Set<String> setUsersAdmins = new Set<String>();
        
        //VERIFICO AS OPORTUNIDADES EM SEU ESTADO DE DADOS ATUAL CONTRA OS DADOS ANTIGOS
        for(Opportunity oppItem : lstOpp)
        {  
            //SE O MEU MAP É NULO, ENTÃO SEI QUE ESTOU INSERINDO
            if(mapOldValues == null)
            {
                lstOppNotify.add(oppItem);
                //ADICIONO A OPORTUNIDADE EM QUESTÃO 
            }
            // O MAP OLD NÃO ESTÁ NULO, ENTÃO SEI QUE ESTOU LIDANDO COM UMA ALTERAÇÃO
            else 
            {
                // PEGO A OPORTUNIDADE COM OS VALORES ANTIGOS ATRAVÉS DO MAP USANDO
                // O ID DA OPP COMO CHAVE
                oldOpp = mapOldValues.get(oppItem.Id);

                // SE O AMOUNT, NEM FASE E NEM TIPO NÃO FOI ALTERADO, NÃO FAÇO NADA E VOU PARA A PRÓXIMA OPP
                if(oldOpp.Amount == oppItem.Amount && oldOpp.Stagename == oppItem.StageName && oldOpp.Type == oppItem.Type)
                    continue;

                //AGORA, SE O AMOUNT FOI ALTERADO, AÍ SIM CHECO O TIPO DE CLIENTE QUE É
                if (oppItem.StageName == 'Negotiation/Review' && oppItem.Amount > 10000 && oppItem.Type == 'New Customer')
                    lstOppNotify.add(oppItem);
            }
        }

        // SE A MINHA LISTA DE OPORTUNIDADES PARA NOTIFICAR FOR VAZIA, TERMINO O MÉTODO POR AQUI E NÃO
        // FAÇO MAIS NADA NELE E EVITO SELECT DE ADM DESNECESSÁRIO
        if(lstOppNotify.isEmpty())
            return;

        // AQUI TEM UMA BURRICE DA SF ABSURDO. O OBJETO PERFIL NÃO POSSUI O CAMPO DEVELOPERNAME
        // ENTÃO TEM QUE BUSCAR SOMENTE PELO NOME, MAS PERFIS PADRÃO MUDAM DE NOME CONFORME O 
        // IDIOMA DO USUÁRIO LOGADO, RECOMENDO USAR UM LABEL CONTENDO O ID DO PERFIL AO INVÉS DO NOME
        // ADICIONEI O FILTRO ISACTIVE PARA EVITAR ERRO DE TENTAR NOTIFICAR USUÁRIO INATIVO
        List<User> lstUserSysAdmin = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true];
        for(User userAdmin : lstUserSysAdmin )
        {
            // VARIÁVEL INTERMEDIÁRIA PARA ARMAZENAR OS IDS DOS USUÁRIOS ADM
            setUsersAdmins.add(userAdmin.Id);
        }

        // LOOP NAS OPPS PARA ALIMENTAR O SET
        for(Opportunity oppItem : lstOppNotify)
        {
            // É POSSÍVEL TAMBÉM VERIFICAR SE O OWNER DA OPP É ATIVO
            // DEVER DE CASA: COMO PEGAR SE O OWNER DA OPP É ATIVO OU NÃO
            // SEM USAR SELECT
            setUsersToNotify.addAll(setUsersAdmins);
            setUsersToNotify.add(oppItem.OwnerId);
            // DEIXEI O DISPARO DO MÉTODO DE FORMA GENÉRICA NO CORPO E TEXTO PARA NÃO ONERAR TANTO.
            // IMAGINE SE TIVER QUE ATUALIZAR 500 DE OPORTUNIDADES PARA 5 ADMINS E CADA OPP TIVER UM
            // OWNER DIFERENTE: 500 * 5 = 2500 DISPAROS DE NOTIFICAÇÕES
            // SE QUISER FAZER ALGO MAIS PERSONALIZADO, RECOMENDO USAR O DISPARO DE E-MAIL VIA APEX
            // PELO MENOS COM ELE É POSSÍVEL BULKIFICAR.
            // DEVER DE CASA: ESTUDAR DISPARO DE E-MAIL PELO APEX
            CustomNotificationUtils.notify('Apex_Test', setUsersToNotify, oppItem.Id, 'New Opportunity Negotiation', 'We are going to have a great client!');

            // LIMPO OS DADOS PARA A NOVA OPORTUNIDADE DO LOOP
            setUsersToNotify.clear();

        }
    }

    //COMO ESTA VERIFICAÇÃO É REPETITIVA, COLOQUEI EM UM
    // MÉTODO A PARTE
    private static String setTopClient(decimal oppAmount)
    {
        if (oppAmount < 10000)
        {
            return 'Good';
        } 
        else if(10000 <= oppAmount && oppAmount < 100000)
        {
            return 'Very Good';        
        } 
        else if (oppAmount > 100000) 
        {
            return 'Excellent';
        }

        return null;
    }
}
