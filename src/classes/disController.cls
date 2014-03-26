public with sharing class disController {

    public Calculator__c[] getCalc(){
        Calculator__c[] calList = [SELECT Name, FirstNumber__c,  Operation__c,Id, Result__c, SecondNumber__c FROM Calculator__c order by Name desc ];
        return calList;
    
    } 

}