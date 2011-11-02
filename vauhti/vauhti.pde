class Vauhtipeli {
  //paaohjelmaluokka
  
  //ikkunan rakentaminen, piirtäminen yms.
}

class Pelimoottori {
  //ei-visuaalinen, siis LOOGINEN kokoava systeemi
  List<Esine> esineet;
}

class Objekti {
  //kaikki esineet mitä siinä näkyy
  
  int x, y;
}




class Mopo extends Objekti {
  //collisiondetecting esineiden kanssa
    //jos kiva esine niin jotain plussaa
    //jos paha esine niin jotain kamalaa
}
