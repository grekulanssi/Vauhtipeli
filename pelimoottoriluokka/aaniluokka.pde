/*
ÄÄNIÄ HIPLAAVA LUOKKA
*/

class Aani {
  
  final int ALA_TAAJUUS = 0;
  final int YLA_TAAJUUS = 200000;
  final int HERKKYYS = 10;
  int viimeksiammuttu = 0;
  int viive = 0;
  
  AudioPlayer djIntro;
  AudioPlayer djNormal;
  AudioPlayer djNos;
  
  

  public Aani() {
    println("3MINIM ON " + minim);
    minim.debugOn();
    lineIn = minim.getLineIn(Minim.STEREO, 512);
    // voikohan tuon fft:n poistaa?
    //fft = new FFT(lineIn.bufferSize(), lineIn.sampleRate());
    
    djIntro = minim.loadFile("introloop.mp3");
    djNormal = minim.loadFile("perusloop.mp3");
    djNos = minim.loadFile("ilokaasuloop.mp3");


  }
  
  public void intronauha() {
    if(djIntro.isPlaying()) {
      return;
    }
    djNormal.pause();
    djNos.pause();
    
    djIntro.loop();
  }
  
  public void perusnauha() {
    if(djNormal.isPlaying()) {
      return;
    }
    djIntro.pause();
    djNos.pause();
    
    djNormal.loop();
  }
  
  public void ilokaasunauha() {
    if(djNos.isPlaying()) {
      return;
    }
    djIntro.pause();
    djNormal.pause();
    
    djNos.loop();
  }
  
  int annaViive() {
    return viive;
  }
  
  private void asetaViive(int v) {
    viive = v;
  }
  
  // otetaan huomioon vain riittävän kovat äänet.
  public boolean voimakkuustesti(){
    //ei voi ampua liian nopeesti
    viive = millis() - this.viimeksiammuttu;
    if (viive < 2000) {
      return false;
    }
    
  
    
    
    float voimakkuus = lineIn.mix.level()*20;
    //println("voimakkuus: " + voimakkuus + ", alaraja: " + HERKKYYS);
    
    if (voimakkuus > HERKKYYS){
      this.viimeksiammuttu = millis();
      return true;
    }
    return false;
  }
  
}
