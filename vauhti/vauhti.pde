Pelimoottori moottori;

void setup() {
  size(400,600);
  background(255);
  moottori = new Pelimoottori();
}

void draw() {
  moottori.piirra();
}


class Pelimoottori {
  //ei-visuaalinen, siis LOOGINEN kokoava systeemi
  List<Esine> esineet;
  Mopo mopo;
  
  Pelimoottori() {
    this.esineet = new ArrayList<Esine>(); 
    this.mopo = new Mopo();
  }
  
  List<Esine> annaEsineet() {
    return this.esineet; 
  }
  
  Mopo annaMopo() {
    return this.mopo;
  }
  
  void piirra() {
      
  }
}


