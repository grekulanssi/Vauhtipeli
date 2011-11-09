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
  int piirtolaskuri; //montako kertaa piirretty
  
  //Luodaan peli
  Pelimoottori(PApplet parent) {
    this.esineet = new ArrayList<Esine>(); 
    this.mopo = new Mopo(width/2, 450);    
    this.esineet.add(new Piikkimatto(200, 300));
    //this.esineet.
    gameover = false;
    this.blob = new Blobfinder(parent);
    this.viimeisinLisays = millis() / 1000;

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
    
    piirtolaskuri++;
    
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
    this.blob.piirraLaatikko(200, 500);

    //this.blob.piirra();
    
    //Nurkkamittarit
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
      
      if (uusix < 60)
        uusix = 60;
      if (uusix > 540)
        uusix = 540;
      return uusix;
  }
  
  
  void siirraEsineita() {
    //Piirretään esineet
    for (int i=0; i<this.esineet.size(); i++) {
      Esine tamaesine = this.esineet.get(i);
      if (tamaesine instanceof Auto) {
        Auto auto = (Auto)tamaesine;
        auto.y++; 
        auto.y++; 
      }
      else {
        tamaesine.y++; 
      }
        
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
    int xArpa1 = int(random(50, 165));
    int xArpa2 = int(random(185, 300));
    int xArpa3 = int(random(315, 420));
    int xArpa4 = int(random(435, 550));
    float kaistaArpa  = random(4);  
    Esine palautus = null;
    
    if(arpa < 50) {  
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
    else if(arpa < 50) {
        
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
     
    else if(arpa < 50) {
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
    else if(arpa < 1000) {
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


