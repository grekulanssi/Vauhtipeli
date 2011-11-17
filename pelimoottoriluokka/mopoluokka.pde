class Mopo extends Objekti {
  //collisiondetecting esineiden kanssa
  //jos kiva esine niin jotain plussaa
  //jos paha esine niin jotain kamalaa
  PImage kuva;
  PImage kuvaO;
  PImage kuvaV;
  public static final int SUORAAN = 100;
  public static final int VASEN = 99;
  public static final int OIKEA = 101;
  int moponTila = SUORAAN;
  
  Mopo(int x, int y) {
   super(x, y, 30,60);
   
   kuva = loadImage("mopo.png");
   kuvaO = loadImage("mopo_o.png");
   kuvaV = loadImage("mopo_v.png");
  }
  
  public void asetaTila(int kaantyminen) {
    if(kaantyminen == SUORAAN || kaantyminen == VASEN || kaantyminen == OIKEA) {
      moponTila = kaantyminen;
    }
    else {
      moponTila = SUORAAN;
    }
  }
    
  void piirra() {
    imageMode(CENTER);
    switch(moponTila) {
      case SUORAAN:
        image(kuva, x,y);
        break;
      case OIKEA:
        image(kuvaO, x,y);
        break;
      case VASEN:
        image(kuvaV, x,y);
        break;
      default:
        image(kuva, x,y);
        break;
    }
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
