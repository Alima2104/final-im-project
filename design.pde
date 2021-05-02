class Design{
  float w,h,x,y;
  String typeof;
  float halfWidth, halfHeight;
  color col;

  Design(){
  }

  void display(float _x, float _y, float _w, float _h, color _c){
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    col = _c;
    noStroke();
    fill(col);
    rect(x,y,w,h);
  }
}
