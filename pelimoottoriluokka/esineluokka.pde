/*
 * Esineitä on kaikki pelissä mopoa vastaan tuleva roina: Autot, lätäköt,
 * jerrykannut ym. Jos jokin esine osuu mopoon, tapahtuu mopolle joko
 * jotain positiivista tai sitten jotain kamalaa, esim. nopeus kasvaa/hidastuu.
 */

abstract class Esine extends Objekti {
  boolean kiva;
  PImage kuva;
  int leveys, korkeus;
  
  public Esine(boolean onkoKiva, String tiedostonimi, int x, int y, int leveys, int korkeus) {
    super(x, y, leveys, korkeus);
    kiva = onkoKiva;
    kuva = loadImage(tiedostonimi);
    this.leveys = leveys;
    this.korkeus = korkeus;
  }
    
  public boolean onKiva() {
    return kiva;
  }
  
  void piirra() {
    imageMode(CENTER);
    image(kuva, x,y);
  }
  
  boolean tormaako(Objekti objekti) {
    int minXEtaisyys = objekti.leveys/2 + this.leveys/2;
    int minYEtaisyys = objekti.korkeus/2 + this.korkeus/2; 
    
    if (Math.abs(this.x-objekti.x) < minXEtaisyys && 
        Math.abs(this.y-objekti.y) < minYEtaisyys) {
         return true; 
        }
        
    return false;
  }
}


class Jerrykannu extends Esine {
  public Jerrykannu(int x, int y) {
    super(true, "jerrykannu.png", x, y, 40, 42);
  }
}

class Ilokaasu extends Esine {
  public Ilokaasu(int x, int y) {
    super(true, "ilokaasu.png", x, y, 50, 46);
  }
  
}

class Oljylatakko extends Esine {
  public Oljylatakko(int x, int y) {
    super(false, "oljylatakko.png", x, y, 40, 35);
  }
}

class Auto extends Esine {
  
  boolean vastaantulija;
  
  public Auto(int x, int y, boolean vastaantulija) {
    super(false, "auto.png", x, y, 70, 40);
    if(vastaantulija) {
      kuva = loadImage("auto_v.png");
    }
    this.vastaantulija = vastaantulija;
  }
  
  public boolean onkoVastaantulija() {
     return this.vastaantulija; 
  }
  
}


class Piikkimatto extends Esine {
  
  public Piikkimatto(int x, int y) {
    super(false, "piikkimatto.png", x, y, int(random(30,81)), 15);
  }
     void piirra() {
      imageMode(CENTER);
      image(kuva, x,y, leveys, korkeus);
    }

}

