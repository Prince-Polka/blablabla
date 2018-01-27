XML font;
XML shape;
XML[] glyphs,shapes,components;
int index = 0;
PShader blablabla;

float[][] glyphimg = new float[1][9*21];

void setfloatarray(PShader target, String sampler2Dname, float[][] source){
    int cols,rows;
    cols = source.length;
    rows = source[0].length;
    PImage array = createImage(rows,cols,ARGB);
    
    for(int i=0,c=0;c<cols;c++)
    for(int     r=0;r<rows;r++)
    array.pixels[i++] = Float.floatToIntBits( source[c][r] );
    target.set(sampler2Dname,array); 
}

void setup(){
  size(500,500,P2D);
  blablabla = loadShader("blablabla.frag");
  font = loadXML("blablabla.svg");
  glyphs = font.getChildren("g");
  for (int i = 0; i < glyphs.length; i++) {
    String id = glyphs[i].getString("inkscape:label");
    if (!id.equals("HACK")){
    shapes = glyphs[i].getChildren();
    for(int j=0; j < shapes.length; j++){
      shape = shapes[j];
      String shape_name = shape.getName();
      
      if(shape_name.equals("ellipse")){
        float cx,cy,rx,ry;
        cx = shape.getFloat("cx");
        cy = shape.getFloat("cy");
        rx = shape.getFloat("rx");
        ry = shape.getFloat("ry");
        
        String style = shape.getString("style");
        
        float addsub = 0.0;
        
        if(style !=null && style.contains("fill") ){
          int fillpos = style.indexOf("fill");
          style = style.substring(fillpos+5,fillpos+12);
          if ( style.equals("#000000") || style.equals("#00ff00") ) addsub = 1.0;
        }
        
        String t = shape.getString("transform");
        
        String[] abcd;
        float a,b,c,d;
        float determinant;
        
        if(t!=null && t.contains("matrix") ){
        t = t.substring(7,t.length()-5);
        abcd = t.split(",");
        a = Float.parseFloat(abcd[0]);
        b = Float.parseFloat(abcd[1]);
        c = Float.parseFloat(abcd[2]);
        d = Float.parseFloat(abcd[3]);}
        
        else {
          t = "1.0,0.0,0.0,1.0";
          a = 1.0;
          b = 0.0;
          c = 0.0;
          d = 1.0;
        }
        
        determinant = a*d - c*b;
        
        glyphimg[0][index*9    ] = d / determinant / rx;
        glyphimg[0][index*9 + 1] = -c / determinant / rx;
        glyphimg[0][index*9 + 2] = -cx / rx;
        
        glyphimg[0][index*9 + 3] = -b / determinant / ry;
        glyphimg[0][index*9 + 4] = a / determinant / ry;
        glyphimg[0][index*9 + 5] = -cy /ry;
        
        glyphimg[0][index*9 + 6] = addsub;
        glyphimg[0][index*9 + 7] = 0.0;
        glyphimg[0][index*9 + 8] = 0.0;
        
        index ++;
      }
      if(shape_name.equals("rect")){
        float x,y,w,h, a,b,c,d;
        String[] abcd = new String[4];
        x = shape.getFloat("x");
        y = shape.getFloat("y");
        w = shape.getFloat("width")/2.0;
        h = shape.getFloat("height")/2.0;
        
        String style = shape.getString("style");
        float addsub = 0.0;
        
        if(style !=null && style.contains("fill") ){
          int fillpos = style.indexOf("fill");
          style = style.substring(fillpos+5,fillpos+12);
          if ( style.equals("#000000") || style.equals("#00ff00") ) addsub = 1.0;
          
        }
        
        String t = shape.getString("transform");
        
        if(t!=null && t.contains("matrix") ){
        t = t.substring(7,t.length()-5);
        a = Float.parseFloat(abcd[0]);
        b = Float.parseFloat(abcd[1]);
        c = Float.parseFloat(abcd[2]);
        d = Float.parseFloat(abcd[3]);
        }
        else {
          t = "1.0,0.0,0.0,1.0";
          a = 1.0;
          b = 0.0;
          c = 0.0;
          d = 1.0;
        }
        
        float determinant = a*d - c*b;
        
        glyphimg[0][index*9    ] = d / determinant / w;
        glyphimg[0][index*9 + 1] = -c / determinant / w;
        glyphimg[0][index*9 + 2] = -(w + x) / w;
        
        glyphimg[0][index*9 + 3] = -b / determinant / h;
        glyphimg[0][index*9 + 4] = a / determinant / h;
        glyphimg[0][index*9 + 5] = -(h + y) / h;
        
        glyphimg[0][index*9 + 6] = addsub;
        glyphimg[0][index*9 + 7] = 0.0;
        glyphimg[0][index*9 + 8] = 0.0;
        
        print( "a["+index+"] = new_rect(");
        print(a+","+b+","+c+","+d+","+t);
        println(", 1.0);");
        index ++;
      }
    }
    }
  }
  setfloatarray(blablabla,"glyphs",glyphimg);
  println(index);
}
void draw(){
  shader(blablabla);
  rect(0,0,width,height);
}