class Mopo extends Objekti {
  //collisiondetecting esineiden kanssa
  //jos kiva esine niin jotain plussaa
  //jos paha esine niin jotain kamalaa
  Mopo(int x, int y) {
   super(x, y, 10,10); 
  }
    
  
  void piirra() {
    fill(255,0,0);
    ellipseMode(CENTER);
    ellipse(x, y, 20, 20);
  }
  
}
