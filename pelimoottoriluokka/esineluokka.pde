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
  
  public Esine annaRandomEsine() {
    float arpa = random(100);
    int xArpa = random(50, 550);
    Esine palautus = null;
    if(arpa < 30) {
      palautus = new Auto(xArpa, -50);
    }
    else if(arpa < 50) {
      palautus = new Oljylatakko(xArpa, -50);
    }
  }
  
}


class Jerrykannu extends Esine {
  public Jerrykannu(int x, int y) {
    super(true, "jerrykannu.png", x, y, 20, 30);
  }
}

class Ilokaasu extends Esine {
    //boolean onkoKiva, String tiedostonimi, int x, int y, int leveys, int korkeus

  public Ilokaasu(int x, int y) {
    super(true, "ilokaasu.png", x, y, 25, 25);
  }
  
}

class Oljylatakko extends Esine {
  public Oljylatakko(int x, int y) {
    super(false, "oljylatakko.png", x, y, 40, 35);
  }
}

class Auto extends Esine {
  
  boolean vastaantulija;
  
  public Auto(int x, int y) {
    super(false, "auto.png", x, y, 70, 40);
    if(random(2) < 1) {
      vastaantulija = true;
    } else {
     vastaantulija = false;
    }
    if(vastaantulija) {
      kuva = loadImage("auto_v.png");
    }
  }
  
}


class Piikkimatto extends Esine {
  
  public Piikkimatto(int x, int y) {
    super(false, "piikkimatto.png", x, y, int(random(20,41)), 10);
  }

}

