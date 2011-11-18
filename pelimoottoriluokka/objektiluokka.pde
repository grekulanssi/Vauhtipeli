abstract class Objekti {
  //kaikki kama mitä pelissä näkyy, sekä mopo että esineet. 
  int x, y, leveys, korkeus;
  
  Objekti(int x, int y, int leveys, int korkeus) {
    this.x=x;
    this.y=y;
    this.leveys=leveys;
    this.korkeus=korkeus;
  }
  
  abstract void piirra();
  
}


class Ammus extends Objekti {
  
 Ammus(int x,int y) {
  super(x,y,10,10);  
 } 
 
 void piirra() {
   ellipse(x,y,this.leveys,this.korkeus);
 }
}
