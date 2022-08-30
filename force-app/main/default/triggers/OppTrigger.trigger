/*
COMO EU HAVIA COMENTADO ANTES, NESTE CASO SÃO AÇÕES NO PRÓPRIO OBJETO
PORTANTO PODEMOS USAR A TRIGGER BEFORE INSERT E BEFORE UPDATE
DEIXEI AS AFTER INSERT E UPDATE TAMBÉM PARA SEPARAR AS RESPONSABILIDADES
A TRIGGER NÃO PODE TER NENHUMA LÓGICA DE NEGÓCIO, 
DEIXE ISSO PARA UMA CLASSE ENCAPSULAR ESSAS VALIDAÇÕES 
DEVER DE CASA: ESTUDAR SOBRE OS TRIGGER HANDLERS
*/

trigger OppTrigger on Opportunity (before insert, before update, after insert, after update) 
{

    //COMO A TRIGGER IRÁ DISPARAR EM DOIS MOMENTOS DE TEMPO, TEM QUE CHECAR QUAL TEMPO
    // QUE ESTÁ RODANDO
    if(Trigger.isBefore)
    {
        //AGORA CHECO A AÇÃO QUE ESTÁ SENDO EXECUTADA, SE É INSERÇÃO OU ATUALIZAÇÃO
        if(Trigger.isInsert)
        {
            // SE FOR INSERT, EU PASSO NULO NA VARIÁVEL MAP
            AccountSupport.updateAccountTopClient(Trigger.new, null);
        }
        else if(Trigger.isUpdate)
        {
            // SE FOR UPDATE, EU PASSO O MAP OLD COMO PARÂMETRO
            AccountSupport.updateAccountTopClient(Trigger.new, Trigger.oldMap);
        }
    }
    else 
    {
        /* O MOTIVO DE TER QUEBRADO EM 2 MOMENTOS DIFERENTES DE TEMPO SE DEVE A
         UM ENTENDIMENTO DE REGRA DE NEGÓCIO:
         ITEM 1 - CONFIGURAÇÃO DE UM DETERMINADO CAMPO NA OPP COM BASE EM VALORES
         ITEM 2 - SE HOUVER UMA ALTERAÇÃO DE VALOR, FASE OU TIPO DE OPP, OS ADM DEVEM SER
            NOTIFICADOS ASSIM COMO O PROPRIETÁRIO DA OPP CASO ELE SEJA ADMIN
        É NESTE SEGUNDO MOMENTO QUE USO O AFTER INSERT/UPDATE, PQ NO BEFORE TODOS OS DADOS JÁ
        FORAM ATUALIZADOS E NÃO HÁ RISCO DE SEREM PREJUDICADOS CASO HAJA ERRO NO MOMENTO DO ITEM 2
         */   

        if(Trigger.isInsert)
        {
            // SE FOR INSERT, EU PASSO NULO NA VARIÁVEL MAP
            AccountSupport.notifyOpportunityChangesOnNegotiation(Trigger.new, null);
        }
        else if(Trigger.isUpdate)
        {
            // SE FOR UPDATE, EU PASSO O MAP OLD COMO PARÂMETRO
            AccountSupport.notifyOpportunityChangesOnNegotiation(Trigger.new, Trigger.oldMap);
        }
    }

}