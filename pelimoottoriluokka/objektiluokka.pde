abstract class Objekti {
  //kaikki esineet mitä siinä näkyy  
  int x, y, leveys, korkeus;
  
  Objekti(int x, int y, int leveys, int korkeus) {
    this.x=x;
    this.y=y;
    this.leveys=leveys;
    this.korkeus=korkeus;
  }
  
  abstract void piirra();
  
}
