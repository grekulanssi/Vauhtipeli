/*
 * Esineitä on kaikki pelissä mopoa vastaan tuleva roina: Autot, lätäköt,
 * jerrykannut ym. Jos jokin esine osuu mopoon, tapahtuu mopolle joko
 * jotain positiivista tai sitten jotain kamalaa, esim. nopeus kasvaa/hidastuu.
 */

abstract class Esine extends Objekti {
  boolean kiva;
  PImage kuva;
  
  public Esine(boolean onkoKiva, String tiedostonimi, int x, int y, int leveys, int korkeus) {
    super(x, y, leveys, korkeus);
    kiva = onkoKiva;
    kuva = loadImage(tiedostonimi);
  }
    
  public boolean onKiva() {
    return kiva;
  }
  
  void piirra() {
    imageMode(CENTER);
    image(kuva, x,y);
  }
  
  boolean tormaako(Mopo mopo) {
    int minXEtaisyys = mopo.leveys/2 + this.leveys/2;
    int minYEtaisyys = mopo.korkeus/2 + this.korkeus/2; 
    
    if (Math.abs(this.x-mopo.x) < minXEtaisyys ||
        Math.abs(this.y-mopo.y) < minYEtaisyys) {
         return true; 
        }
        
    return false;
  }
}

/*
class Jerrykannu extends Esine {
  public Jerrykannu() {
    super(true);
  }
}

class Ilokaasu extends Esine {
  
  public Ilokaasu() {
    super(true);
  }
  
}

class Oljylatakko extends Esine {
  public Oljylatakko() {
    super(false);
  }
}

class Auto extends Esine {
  
  boolean vastaantulija;
  
  public Auto(boolean tuleeVastaan) {
    super(false);
    vastaantulija = tuleeVastaan;
  }
  
}
*/

class Piikkimatto extends Esine {
  
  public Piikkimatto(int x, int y) {
    super(false, "piikkimatto.png", x, y, 10, 10);
  }
}

