public class RectangleStatic {

    public static void perimeter(){
        Decimal Length=5.5,Breadth=4;
        Decimal perimeter=2*(Length+Breadth);
        System.debug('Perimeter is '+perimeter);
            
    }public static void area(){
        Decimal Length=5.5,Breadth=4;
        Decimal area= Length*Breadth;
        System.debug('Area is '+area);
    }
}