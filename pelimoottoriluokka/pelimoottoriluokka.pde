/* 
Pakolliset processing-metodit
*/
Pelimoottori moottori;
void setup() {
  size(600,650);
  moottori = new Pelimoottori();
}

void draw() {
  moottori.piirra();
}

void keyPressed() {
  moottori.painettu();
}


/*
Pelimoottori
*/

class Pelimoottori {
  //ei-visuaalinen, siis LOOGINEN kokoava systeemi
  List<Esine> esineet;
  Mopo mopo;
  boolean gameover;
  
  //Luodaan peli
  Pelimoottori() {
    this.esineet = new ArrayList<Esine>(); 
    this.mopo = new Mopo(width/2, 600);    
    this.esineet.add(new Piikkimatto(200, 300));
    gameover = false;
  }
   
  //Näppäintä on painettu
  void painettu() {
    if (key == CODED) {
        switch (keyCode) {
         case UP:
          this.mopo.y--;
          break;
         case DOWN:
           this.mopo.y++;
           break;
         case LEFT:
           this.mopo.x--;
           break;
         case RIGHT:
           this.mopo.x++;
           break;
      }
    }
  }
  
  //Piirretään pelin tilanne
  void piirra() {
    
    //Jos gameover niin ei piirretä
    if (this.gameover) {
      return;
    }
    
    background(255);
    
    siirraEsineita();

    //Piirretään objektit
    this.mopo.piirra();
    for (int i=0; i<this.esineet.size(); i++) {
      this.esineet.get(i).piirra(); 
    }
  }
  
  void siirraEsineita() {
    //Piirretään esineet
    for (int i=0; i<this.esineet.size(); i++) {
      this.esineet.get(i).y++;
    }  
    
    //Tarkistetaan törmäykset
    for (int i=0; i<this.esineet.size(); i++) {
      if (this.esineet.get(i).tormaako(this.mopo)) {
        gameover = true; 
        println("JOU");
      }
  
    }  
    
    //TODO tuhoa piiloon menneet esineet
  }
  
}


