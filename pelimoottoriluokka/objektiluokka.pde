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
