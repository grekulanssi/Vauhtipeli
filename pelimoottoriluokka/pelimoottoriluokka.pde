/* 
Pakolliset processing-metodit
*/
Pelimoottori moottori;
void setup() {
  size(600,650);
  moottori = new Pelimoottori(this);
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
  Blobfinder blob;
  int alkuaika;
  boolean esineLisatty;
  
  //Luodaan peli
  Pelimoottori(PApplet parent) {
    this.esineet = new ArrayList<Esine>(); 
    this.mopo = new Mopo(width/2, 450);    
    this.esineet.add(new Piikkimatto(200, 300));
    gameover = false;
    this.blob = new Blobfinder(parent);
    this.alkuaika = millis();
    this.esineLisatty = false;

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
    
    int kulunutAika = (int) (millis() - this.alkuaika) / 1000;   
    //Jos gameover niin ei piirretä
    if (this.gameover) {
      return;
    }
    
    background(255);
    
    
    //Piirretään laatikkohahmottelu
    strokeWeight(0);
    
    //Sivut pensaita
    rect(0,0,50,500);
    rect(550,0,50,500);
    
    //Pelaajan kuva
    //rect(200,500,200,150);
    imageMode(CORNER);
    image(cam, 200, 500, 200, 150);
    //this.blob.piirra();
    
    //Nurkkamittarit
    fill(0,255,0);
    rect(0,500,200,150);
    rect(400,500,200,150);
    
    
    siirraEsineita();

    this.mopo.x = this.blob.annaBlobinX();
    this.blob.preprocess();
    //println(this.blob.annaBlobinX());
    
    //Piirretään objektit
    this.mopo.piirra();
    for (int i=0; i<this.esineet.size(); i++) {
      this.esineet.get(i).piirra(); 
    }
    if ((kulunutAika % 5) == 0 && this.esineLisatty == false){
      esineet.add(annaRandomEsine());
      this.esineLisatty = true;
    }
    else {
      this.esineLisatty = false;
    }
    println("kulunutAika: " + kulunutAika);
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
      }
  
    }  
    
    //tuhotaan piiloon menneet esineet
    for(int j = 0; j < this.esineet.size(); j ++) {
      Esine e = this.esineet.get(j);
      if(e.y > (500+(e.korkeus/2)+40)) {
        esineet.remove(e);
      }
    }
  }
  // Antaa satunnaisen uuden esineen.
  public Esine annaRandomEsine() {
    float arpa = random(100);
    int xArpa = int(random(50, 550));
    Esine palautus = null;
    if(arpa < 30) {
      palautus = new Auto(xArpa, -50);
    }
    else if(arpa < 50) {
      palautus = new Oljylatakko(xArpa, -50);
    }
    else if(arpa < 70) {
      palautus = new Jerrykannu(xArpa, -50);
    }
    else if(arpa < 90) {
      palautus = new Piikkimatto(xArpa, -50);
    }
    else {
      palautus = new Ilokaasu(xArpa, -50);
    }  
    return palautus;
  }
  
}


