public class CalController {

    public Integer FirstNumber{get;set;}
    public Integer SecondNumber{get;set;}
    integer Result; 
    public Integer getResult() {
        return Result;
    }
    
    public Pagereference Add(){
        Result = FirstNumber + SecondNumber;
        save('+');
        pagereference pageref = new pagereference('/apex/dispCalculator');
        return pageref;    
    }
    public Pagereference Substract(){
        Result = FirstNumber - SecondNumber;
        save('-');
        
        pagereference pageref = new pagereference('/apex/dispCalculator');
        return pageref;  
    }
    public Pagereference Multiply(){
        Result = FirstNumber * SecondNumber;
        save('*');
        
        pagereference pageref = new pagereference('/apex/dispCalculator');
        return pageref;   
    }
    public Pagereference Divide(){
        Result = FirstNumber / SecondNumber;
        save('/');
        
        pagereference pageref = new pagereference('/apex/dispCalculator');
        return pageref;    
    }
    
    public void save(String op){
        Calculator__c calc = new Calculator__c();
        calc.FirstNumber__c = FirstNumber;
        calc.SecondNumber__c = SecondNumber;
        calc.Result__c = Result;
        calc.Operation__c = op;
        
        insert calc;
    }
    
}