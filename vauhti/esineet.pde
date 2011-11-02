abstract class Esine extends Objekti {
  boolean kiva;
  PImage kuva;
  
  public Esine(boolean onkoKiva) {
    kiva = onkoKiva;
    kuva = lataaKuva();
    x = 0;
    y = -korkeus;
  }
  
  private PImage lataaKuva() {
    String url = this.getClass().getName() + ".png";
    return loadImage(url);
  }
  
  public boolean onKiva() {
    return kiva;
  }
  
  void draw() {
    image(kuva, x,y);
  }
}

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

class Piikkimatto extends Esine {
  
  public Piikkimatto() {
    super(false);
  }
}

