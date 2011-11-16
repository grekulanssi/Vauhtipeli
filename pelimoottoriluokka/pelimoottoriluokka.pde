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



/*
Pelimoottori
*/

class Pelimoottori {
  //ei-visuaalinen, siis LOOGINEN kokoava systeemi
  List<Esine> esineet;
  Mopo mopo;
  boolean gameover;
  Blobfinder blob;
  int viimeisinLisays;
  int aloitusaika;
  int piirtolaskuri; //käytetään taustan rullaamiseen
  PImage aloituskuva;
  PImage aloitusnappi;
  boolean piirrapeli;
  int nopeuskerroin = 1;
  
  /* taustalla näkyvä asvaltti talletetaan attribuuttiin
   * nos tarkoittaa ilokaasua (jos et tienny niin katso Hurjapäät-leffa)
   */
  PImage taustakuva;
  PImage taustakuvaNos;
  
  boolean nosMode;
  int nosKelloM;
  int nosKello;
  
  //Luodaan peli
  Pelimoottori(PApplet parent) {
    this.esineet = new ArrayList<Esine>(); 
    this.mopo = new Mopo(width/2, 450);    
    this.esineet.add(new Piikkimatto(200, 300));
    //this.esineet.
    gameover = false;
    this.blob = new Blobfinder(parent);
    this.viimeisinLisays = millis() / 1000;
    this.piirrapeli = false;
    
    taustakuva = loadImage("asvaltti.png");
    taustakuvaNos = loadImage("asvaltti_nos.png");
    aloituskuva = loadImage("start.png");
    aloitusnappi = loadImage("startbutton.png");
    
    nosMode = false;
    nosKello = 0;
    nosKelloM = 0;

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
  
  void piirra() {
    if (mousePressed && mouseX <= 360 && mouseX >= 240 && 
          mouseY >= 550 && mouseY <= 550+33) {
      samplecolor = this.blob.annaKeskipisteenVari();
      piirrapeli = true;
      this.aloitusaika = millis()/1000;
    }
      
      
    if (piirrapeli)
      piirraPeli(); 
    else
      piirraValikko();
  }
  
  void piirraValikko() {
    
    image(aloituskuva,0,0);
    
    //videokuva
    this.blob.piirraLaatikko(200,230, true);
    
    //keskelle merkki
    int merkinPituus = 10;
    stroke(255,255,255);
    //pysty
    line(300,305-merkinPituus,300,305+merkinPituus);
    //vaaka
    line(300-merkinPituus,305,300+merkinPituus,305);
    stroke(0);
    
    //nenänvärilaatikko
    color nena = this.blob.annaKeskipisteenVari();
    fill(nena);    
    rect(250,415,100,100);
    
    //aloitusnappi
    image(aloitusnappi, 240, 550);
  }
  
  //Piirretään pelin tilanne
  void piirraPeli() {
        
    //piirtolaskuria käytetään taustan rullaamiseen
    //se ei näytä välttämättä oikeaa piirtokertojen määrää
    piirtolaskuri = piirtolaskuri + this.nopeuskerroin;
    
    //Jos gameover niin ei piirretä
    if (this.gameover) {
      return;
    }
    
    if(nosMode) {
      this.nopeuskerroin = ((millis()/1000) - this.aloitusaika)/5+7;
    }
    else {
      this.nopeuskerroin = ((millis()/1000) - this.aloitusaika)/5+1;
    }
    
    background(255);
    

    imageMode(CORNER);
    //Piirretään tausta jatkuvana
    if(nosMode) {
      image(taustakuvaNos, 0,this.piirtolaskuri%500, 600,500);
      image(taustakuvaNos, 0,this.piirtolaskuri%500-500, 600,500);
    }
    else {
      image(taustakuva, 0,this.piirtolaskuri%500, 600,500);
      image(taustakuva, 0,this.piirtolaskuri%500-500, 600,500);
    }
    imageMode(CENTER);
    
    strokeWeight(0);
    
    //Keltaiset keskiviivat
    fill(190,180,10,200);
    rect(width/2-26,0, 20,500);
    rect(width/2+2,0, 20,500);
    
    //valkoset kaistaviivat jatkuvana
    fill(240,240,240,240);
    if(nosMode) {
      println("I NEED NOOOOOOSSSS");
      for(int v = 0; v < 6; v++) {
        rect(width/4+4,(v*100)+this.piirtolaskuri%500, 20,60+(millis() - nosKelloM));
        rect(width/4+4,(v*100)+this.piirtolaskuri%500-500, 20,60+(millis() - nosKelloM));
      
        rect(width*3/4-28,(v*100)+this.piirtolaskuri%500, 20,60+this.nopeuskerroin);
        rect(width*3/4-28,(v*100)+this.piirtolaskuri%500-500, 20,60+this.nopeuskerroin);
      }
    }
    else {
      for(int v = 0; v < 6; v++) {
        rect(width/4+4,(v*100)+this.piirtolaskuri%500, 20,60);
        rect(width/4+4,(v*100)+this.piirtolaskuri%500-500, 20,60);
      
        rect(width*3/4-28,(v*100)+this.piirtolaskuri%500, 20,60);
        rect(width*3/4-28,(v*100)+this.piirtolaskuri%500-500, 20,60);
      }
    }
    
    //Pelaajan kuva
    this.blob.piirraLaatikko(200, 500, true);

    //this.blob.piirra();
    
    //Nurkkamittarit TODO
    fill(0,255,0);
    rect(0,500,200,150);
    rect(400,500,200,150);
    
    
    siirraEsineita();

    this.mopo.x = this.laskeMoponX();
    //println(this.blob.annaBlobinX());
    
    //Piirretään objektit
    this.mopo.piirra();
    for (int i=0; i<this.esineet.size(); i++) {
      this.esineet.get(i).piirra(); 
    }
    if ((millis()/1000) - this.viimeisinLisays >= 3) {
      esineet.add(annaRandomEsine());
      this.viimeisinLisays = (millis() / 1000);
      
    }
  }
  
  int laskeMoponX() {
      int vanhax = this.mopo.x;
      int kallistusx = this.blob.annaBlobinX()/10;
      int uusix = vanhax + kallistusx;
      
      if(kallistusx < 0) {
        mopo.asetaTila(Mopo.VASEN);
      }
      else if(kallistusx > 0) {
        mopo.asetaTila(Mopo.OIKEA);
      }
      else {
        mopo.asetaTila(Mopo.SUORAAN);
      }
      
      if (uusix < 60)
        uusix = 60;
      if (uusix > 540)
        uusix = 540;
      return uusix;
  }
  
  
  void siirraEsineita() {
    if(nosMode && (millis() / 1000) - nosKello >= 7) {
      nosMode = false;
      nosKello = 0;
    }
    //Piirretään esineet
    for (int i=0; i<this.esineet.size(); i++) {
      Esine tamaesine = this.esineet.get(i);
      if (tamaesine instanceof Auto) {
        Auto auto = (Auto)tamaesine;

        if (auto.onkoVastaantulija()) {
          //Vastaantulijoita siirretään kolme pikseliä
          auto.y = auto.y+2*this.nopeuskerroin;
        }
        else {
          //Siirretään auto joka toisella piirtokerralla pikseli
          if (this.nopeuskerroin == 1 && this.piirtolaskuri % 2 == 0) {
            auto.y++;
          }
          else {
            auto.y = auto.y+this.nopeuskerroin/2;
          }
          
        }
      }
      else {
        tamaesine.y = tamaesine.y+this.nopeuskerroin;; 
      }
        
    }  
    
    //Tarkistetaan törmäykset
    for (int i=0; i<this.esineet.size(); i++) {
      Esine e = this.esineet.get(i);
      if (e.tormaako(this.mopo)) {
        if(!e.onKiva()) {
          if(e instanceof Auto) {
            //RAJAHDYS
            gameover = true;
          }
          else if(e instanceof Piikkimatto) {
            gameover = true;
          }
          else if(e instanceof Oljylatakko) {
            //JOTAIN LIUKASTELUA;
          }
        }
        else {
          this.esineet.remove(i);
          if(e instanceof Ilokaasu) {
            nosMode = true;
            nosKelloM = millis();
            nosKello = nosKelloM / 1000;
          }
          else if(e instanceof Jerrykannu) {
            //JOTAIN BENSAA LISAA JOTENKI
          }
        }
        return;
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
    int xArpa1 = int(random(50, 165));
    int xArpa2 = int(random(185, 300));
    int xArpa3 = int(random(315, 420));
    int xArpa4 = int(random(435, 550));
    float kaistaArpa  = random(4);  
    Esine palautus = null;
    
    if(arpa < 0) {  
      if (kaistaArpa < 1){
      palautus = new Auto(xArpa1, -50, true);
      }
      else if (kaistaArpa < 2){
      palautus = new Auto(xArpa2, -50, true);
      }
      else if (kaistaArpa < 3){
      palautus = new Auto(xArpa3, -50, false);
      }
      else {
      palautus = new Auto(xArpa4, -50, false);
      }
    }
    else if(arpa < 0) {
        
      if (kaistaArpa < 1){
      palautus = new Oljylatakko(xArpa1, -50);
      }
      else if (kaistaArpa < 2){
      palautus = new Oljylatakko(xArpa2, -50);
      }
      else if (kaistaArpa < 3){
      palautus = new Oljylatakko(xArpa3, -50);
      }
      else {
      palautus = new Oljylatakko(xArpa4, -50);
      }
    }
     
    else if(arpa < 0) {
       if (kaistaArpa < 1){
      palautus = new Jerrykannu(xArpa1, -50);
      }
      else if (kaistaArpa < 2){
      palautus = new Jerrykannu(xArpa2, -50);
      }
      else if (kaistaArpa < 3){
      palautus = new Jerrykannu(xArpa3, -50);
      }
      else {
      palautus = new Jerrykannu(xArpa4, -50);
      }
    }
    else if(arpa < 0) {
       if (kaistaArpa < 2){
      palautus = new Piikkimatto(100, -50);
      }
      else {
      palautus = new Piikkimatto(490, -50);
      }
    }
    else {
      if (kaistaArpa < 1){
      palautus = new Ilokaasu(xArpa1, -50);
      }
      else if (kaistaArpa < 2){
      palautus = new Ilokaasu(xArpa2, -50);
      }
      else if (kaistaArpa < 3){
      palautus = new Ilokaasu(xArpa3, -50);
      }
      else {
      palautus = new Ilokaasu(xArpa4, -50);
      }
    }
    return palautus;
  }
}


