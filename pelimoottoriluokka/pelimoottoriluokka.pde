import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput lineIn;
FFT fft;

/* 
Pakolliset processing-metodit
*/
Pelimoottori moottori;
void setup() {
  size(600,650);
  
  minim = new Minim(this);
  moottori = new Pelimoottori(this);
}

void draw() {
  moottori.piirra();
}

/*
Pelimoottori
*/

class Pelimoottori {
  
  Aani aani;
    
  //ei-visuaalinen, siis LOOGINEN kokoava systeemi
  List<Esine> esineet;
  List<Ammus> ammukset;
  Mopo mopo;
  boolean gameover;
  Blobfinder blob;
  int viimeisinLisays;
  int aloitusaika;
  int piirtolaskuri; //käytetään taustan rullaamiseen
  PImage aloituskuva;
  PImage aloitusnappi;
  boolean piirrapeli;
  int nopeuskerroin;
  double bensaa; //bensaa on 0-20 litraa
  float lopputulos;
  boolean voitto;
  
  /* taustalla näkyvä asvaltti talletetaan attribuuttiin
   * nos tarkoittaa ilokaasua (jos et tienny niin katso Hurjapäät-leffa)
   */
  PImage taustakuva;
  PImage taustakuvaNos;
  PImage peliohi;
  PImage restart;
  PImage nopeusmittari;
  PImage bensamittari;
  PImage bensavalo;
  
  boolean nosMode;
  int nosKello;
  int nosY;
  int kaistaviivanpituus;
  
  boolean oljyaRenkaissa;
  int oljyKello;
  
  
  //Luodaan peli
  Pelimoottori(PApplet parent) {
    
    aani = new Aani();
    
    this.blob = new Blobfinder(parent);
    aloituskuva = loadImage("start.png");
    aloitusnappi = loadImage("startbutton.png");
    
    taustakuva = loadImage("asvaltti.png");
    taustakuvaNos = loadImage("asvaltti_nos.png");
    nopeusmittari = loadImage("nopeusmittari.png");
    bensamittari = loadImage("bensamittari.png");
    bensavalo = loadImage("bensavalo.png");
    
    peliohi = loadImage("gameover.png");
    restart = loadImage("restart.png");
    
    this.piirrapeli = false;
    
    this.uusiPeli();
  }
  
 void uusiPeli() {
      
    this.esineet = new ArrayList<Esine>(); 
    this.ammukset = new ArrayList<Ammus>(); 
    this.mopo = new Mopo(width/2, 450);    
    //this.esineet.add(new Piikkimatto(200, 300));
    //this.esineet.
    gameover = false;
    this.nopeuskerroin = 1;
    this.bensaa = 20;
    this.aloitusaika = millis()/1000;
    println(this.nopeuskerroin);
    this.viimeisinLisays = millis() / 1000;   
    this.lopputulos = -1;
    this.voitto = false;
    
   nosMode = false;
   nosKello = 0;
   nosY = 0;

   kaistaviivanpituus = 60;

   oljyaRenkaissa = false;
   
  }
   
   /*
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
    
  }*/
  
  //Yleismetodi piirrä
  void piirra() {
    
         
    //Piirretään peli      
    if (piirrapeli) {
      piirraPeli();
      soitaAanet();
    }
    //Piirretään valikko
    else {
      ///Aloitusruudussa valitaan nenän väri
      if (mousePressed && mouseX <= 360 && mouseX >= 240 && 
          mouseY >= 550 && mouseY <= 550+33) {
        samplecolor = this.blob.annaKeskipisteenVari();
        piirrapeli = true;
        this.aloitusaika = millis()/1000;
      }
      piirraValikko();
    }
  }
 
  void soitaAanet() {
    if(this.gameover){
      if(this.voitto) {
        aani.ilokaasunauha();
      }
      else {
        aani.intronauha();
      }
    }
    else {
      if(nosMode) {
        aani.ilokaasunauha();
      }
      else {
        aani.perusnauha();
      }
    }
  }
  
  void piirraValikko() {
    
    aani.intronauha();
    
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

    
    //piirtolaskuria käytetään taustan näyttämiseen/rullaamiseen
    //se ei näytä välttämättä oikeaa piirtokertojen määrää
    piirtolaskuri = piirtolaskuri + this.nopeuskerroin;
    
    //Jos gameover niin ei piirretä
    if (this.gameover) {
            
      //Piirretään lopputulos-laatikko
      imageMode(CENTER);
      image(peliohi, width/2, 250);
      image(restart, width/2, 350);
      
      //näytetään tulos sekunteina
      float kulunutaika = (float)millis()/1000-this.aloitusaika;
      if (this.lopputulos < 0) {
        this.lopputulos = kulunutaika;
      }
      text(this.lopputulos + " seconds", width/2-45, 270);
      
      //jos klikataan restart
      if (mousePressed && mouseX >= (width/2)-96 && mouseX <= (width/2)+96 && 
          mouseY >= 350-26 && mouseY <= 350+26) {
            println("UUSI");
            this.uusiPeli();
      }
      
      return;
    }

    //toteutetaan pelilogiikka
    pelilogiikka();   
    
    
    //piirretään esineet    
    background(255);
    

    imageMode(CORNER);
    //Piirretään tausta jatkuvana
    if(nosMode) {
      image(taustakuvaNos, 0,this.piirtolaskuri%650, 600,650);
      image(taustakuvaNos, 0,this.piirtolaskuri%650-650, 600,650);
    }
    else {
      image(taustakuva, 0,this.piirtolaskuri%650, 600,650);
      image(taustakuva, 0,this.piirtolaskuri%650-650, 600,650);
    }
    imageMode(CENTER);
    
    noStroke();
    
    //Keltaiset keskiviivat
    fill(190,180,10,200);
    rect(width/2-26,0, 20,500);
    rect(width/2+2,0, 20,500);
    
    //valkoset katkoviivat
    fill(240,240,240,240);
    if(nosMode) {
      println("I NEED NOOOOOOSSSS");
      if(kaistaviivanpituus < 120) {
        kaistaviivanpituus ++;
      }
    }
    else {
      if(kaistaviivanpituus > 60) {
        kaistaviivanpituus --;
      }
    }
    for(int v = 0; v < 6; v++) {
      rect(width/4+4,(v*100)+this.piirtolaskuri%500, 20,kaistaviivanpituus);
      rect(width/4+4,(v*100)+this.piirtolaskuri%500-500, 20,kaistaviivanpituus);
      
      rect(width*3/4-28,(v*100)+this.piirtolaskuri%500, 20,kaistaviivanpituus);
      rect(width*3/4-28,(v*100)+this.piirtolaskuri%500-500, 20,kaistaviivanpituus);
    }
    
    //PIIRRETÄÄN ESINEET
    for (int i=0; i<this.esineet.size(); i++) {
      this.esineet.get(i).piirra(); 
    }
    
    //PIIRRETÄÄN AMMUKSET
    fill(0);
    for (int i=0; i<this.ammukset.size(); i++) {
      this.ammukset.get(i).piirra(); 
    }
    
    //println(this.blob.annaBlobinX());
    
    //PIIRRETÄÄN MOPEDI!!!!!!!!!!!
    
    this.mopo.x = this.laskeMoponX();
    this.mopo.y = this.laskeMoponY();
    
    this.mopo.piirra();
    
    
    if ((millis()/1000) - this.viimeisinLisays >= 3) {
      esineet.add(annaRandomEsine());
      this.viimeisinLisays = (millis() / 1000);
      
    }
    
    //Pelaajan kuva
    this.blob.piirraLaatikko(200, 500, true);

    //this.blob.piirra();
    
    //Nopeus- ja bensamittarit
    image(nopeusmittari, 400,500);
    image(bensamittari, 0, 500);
    
    //Nopeusmittarin viisari
    pushMatrix();
    translate(494,596);
    strokeWeight(1);
    fill(255,0,0);
    stroke(200);
    rotate(-PI-PI/6);
    rotate( (PI/14) * (this.annaNopeuskerroin()) );
    rect(0,0,50,5);
    stroke(0);
    popMatrix();
    
    //Bensamittarin viisari
    pushMatrix();
    translate(65,610);
    strokeWeight(1);
    fill(255,0,0);
    stroke(200);
    rotate(-PI/2+PI/20);
    rotate( (float) ((PI/2.2) * (1- this.bensaa/20)) );
    rect(0,0,50,5);
    stroke(0);
    popMatrix();
    
    //Bensavalo
    if (this.bensaa < 4) {
     image(bensavalo, 20, 580);
    }
    
    //fill(255,0,0);
    //rect(500,0, 200,50);
    fill(255);
    float kulunutaika = (float)millis()/1000-this.aloitusaika;

    text("SHIFT # " + (this.nopeuskerroin/3+1), 460, 620); 

    //println("Nopeus: " + this.annaNopeuskerroin());
  }
  
  float annaNopeuskerroin() {
    return (this.nopeuskerroin) + ((float)((millis()) - this.aloitusaika*1000)%5000)/5000 ; 
  }
  
  int laskeMoponX() {
      int vanhax = this.mopo.x;
      int kallistusx = this.blob.annaBlobinX()/10;
      
      if(kallistusx < 0) {
          mopo.asetaTila(Mopo.VASEN);
      }
      else if(kallistusx > 0) {
          mopo.asetaTila(Mopo.OIKEA);
      }
      else {
        mopo.asetaTila(Mopo.SUORAAN);
      }
      
      if(oljyaRenkaissa) {
        kallistusx = -kallistusx;
      }
      int uusix = vanhax + kallistusx;
      
      if (uusix < 60)
        uusix = 60;
      if (uusix > 540)
        uusix = 540;
      return uusix;
  }
  
  int laskeMoponY() {
    int vanhaY = this.mopo.y;
    int uusiY = vanhaY;
    if(vanhaY < 450) {
      if(nosMode) {
        uusiY --;
      }
    }
    if(!nosMode) {
      if(vanhaY < 450) {
        uusiY ++;
      }
    }
    else {
      if(vanhaY-nosY > 300-nosY) {
        uusiY --;
      }
    }
    return uusiY;
  }
  
  
  void pelilogiikka() {
    
    if (this.bensaa <= 0) {
      gameover = true;
      return;
    }
    
      
    //kasvatetaan nopeutta
    this.nopeuskerroin = ((millis()/1000) - this.aloitusaika)/5+(nosMode? 7 : 1);
    
    if (this.nopeuskerroin > 19 && !nosMode) {
      this.nopeuskerroin = 19;  
    }
    
    //vähennetään bensaa
    this.bensaa -= 0.008;
    if (this.bensaa < 0)
      this.bensaa = 0;
      
    if(nosMode && (millis() / 1000) - nosKello >= 7) {
      nosMode = false;
      nosKello = 0;
    }
    if(oljyaRenkaissa && (millis() / 1000) - oljyKello >= 7) {
      oljyaRenkaissa = false;
      oljyKello = 0;
    }
    
    //Lisätään ammus
    if (this.aani.voimakkuustesti()) {
      this.ammukset.add(new Ammus(this.mopo.x,this.mopo.y)); 
    }
    
    //siirretään ammuksia
    for (int i=0; i<this.ammukset.size(); i++) {
      Ammus laukaus = this.ammukset.get(i);
      laukaus.y -= 10;
    }
    
    //Siirretään esineet
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
      
      //törmääkö esine ammukseen
      for (int q=0; q<this.ammukset.size() && !(e instanceof Piikkimatto); q++) {
        Ammus mus = this.ammukset.get(q);
        if (e.tormaako(mus)) {
          this.esineet.remove(e);
          this.ammukset.remove(q);
          break; 
        }
      }
      
      //törmääkö esine mopoon
      if (e.tormaako(this.mopo)) {        
       
          if(e instanceof Auto) {
            //RAJAHDYS
            gameover = true;
            return;
          }
          else if(e instanceof Piikkimatto) {
            gameover = true;
            return;
          }
          else if(e instanceof Oljylatakko) {
            //JOTAIN LIUKASTELUA;
            oljyaRenkaissa = true;
            oljyKello = millis() / 1000;
            this.esineet.remove(i);
          }
          else if(e instanceof Jerrykannu) {
            println(this.bensaa);
            this.bensaa += 5;
            println(this.bensaa);
            if (this.bensaa > 20)
              this.bensaa = 20;
            this.esineet.remove(i);
          }      
        
          else  if(e instanceof Ilokaasu) {
              nosMode = true;
              nosKello = millis() / 1000;
              nosY = this.mopo.y;
              this.esineet.remove(i);
          }

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
    int xArpa1 = int(random(80, 160));
    int xArpa2 = int(random(180, 270));
    int xArpa3 = int(random(330, 415));
    int xArpa4 = int(random(440, 530));
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
    else if(arpa < 60) {
        
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
     
    else if(arpa < 75) {
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
    else if(arpa < 85) {
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
    //return new Auto(100,-50, true);
  }
}


