public class SquareWithConstructor {
    decimal l;
    public  SquareWithConstructor(decimal length){
         l=length;
    }
    public void perimeter(){
        decimal perimeter=4*l;
        System.debug('Perimeter is '+perimeter);
    }
    public void area(){
  
        decimal area=l*l;
        System.debug('area is '+area);
    }
}