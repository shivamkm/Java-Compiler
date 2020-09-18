
// Java program to illustrate setShort() method 
  
import java.lang.reflect.Field; 
  
public class GFG { 
  
    public static void main(String[] args) 
        throws Exception 
    { 
  
        // create user object 
        Employee emp = new Employee(); 
  
        // print value of uniqueNo 
        System.out.println( 
            "Value of uniqueNo before "
            + "applying setShort is "
            + emp.uniqueNo); 
  
        // Get the field object 
        Field field 
            = Employee.class
                  .getField("uniqueNo"); 
  
        // Apply setShort Method 
        field.setShort(emp, (short)134); 
  
        // print value of uniqueNo 
        System.out.println( 
            "Value of uniqueNo after "
            + "applying setShort is "
            + emp.uniqueNo); 
    } 
} 
  
// sample class 
class Employee { 
  
    // static short values 
    public static short uniqueNo = 239; 
} 

