class Mopo extends Objekti {
  //collisiondetecting esineiden kanssa
  //jos kiva esine niin jotain plussaa
  //jos paha esine niin jotain kamalaa
  PImage kuva;
  PImage kuva_k;
  public static final int SUORAAN = 100;
  public static final int VASEN = 99;
  public static final int OIKEA = 101;
  int moponTila = SUORAAN;
  
  Mopo(int x, int y) {
   super(x, y, 30,60);
   
   kuva = loadImage("mopo.png");
   kuva_k = loadImage("mopo_k.png");
  }
  
  public int asetaTila(int kaantyminen) {
    if(kaantyminen == SUORAAN || kaantyminen == VASEN || kaantyminen == OIKEA) {
      moponTila = kaantyminen;
    }
    else {
      moponTila = SUORAAN;
    }
  }
    
  
  void piirra() {//TODO: switch näyttäs kivemmalta!
    ImageMode(CENTER);
    if(moponTila == SUORAAN) {
      image(kuva, x,y);
    }
    else {
      if(moponTila == OIKEA) {
        image(kuva_k, x,y);
      }
      else {
        if(moponTila == VASEN) {
          //TÄHÄN KUVAN PEILAUS!
          image(kuva_k, x,y);
        }
    }
    /*fill(255,0,0);
    ellipseMode(CENTER);
    ellipse(x, y, 20, 20);
    */  
  }
  
}

/*
 PImage kuva;
  int leveys, korkeus;
  
  public Esine(boolean onkoKiva, String tiedostonimi, int x, int y, int leveys, int korkeus) {
    super(x, y, leveys, korkeus);
    kiva = onkoKiva;
    kuva = loadImage(tiedostonimi);
    this.leveys = leveys;
    this.korkeus = korkeus;
  }
  */
