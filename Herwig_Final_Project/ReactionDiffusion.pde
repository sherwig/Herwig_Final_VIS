// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for this video: https://youtu.be/BV9ny785UNc

// Written entirely based on
// http://www.karlsims.com/rd.html

// Also, for reference
// http://hg.postspectacular.com/toxiclibs/src/44d9932dbc9f9c69a170643e2d459f449562b750/src.sim/toxi/sim/grayscott/GrayScott.java?at=default


class ReactionDiffusion
{
  float dA = 1.0;
  float dB = 0.3;
  float feed = 0.052;
  float k = 0.065;
  
  class Cell {
    float a;
    float b;
  
    Cell(float a_, float b_) {
      a = a_;
      b = b_;
    }
  }
  
  
  void update() {
    for (int i = 1; i < width-1; i++) {
      for (int j = 1; j < height-1; j ++) {
  
        Cell spot = prev[i][j];
        Cell newspot = grid[i][j];
  
        float a = spot.a;
        float b = spot.b;
  
        float laplaceA = 0;
        laplaceA += a*-1;
        laplaceA += prev[i+1][j].a*0.2;
        laplaceA += prev[i-1][j].a*0.2;
        laplaceA += prev[i][j+1].a*0.2;
        laplaceA += prev[i][j-1].a*0.2;
        laplaceA += prev[i-1][j-1].a*0.05;
        laplaceA += prev[i+1][j-1].a*0.05;
        laplaceA += prev[i-1][j+1].a*0.05;
        laplaceA += prev[i+1][j+1].a*0.05;
  
        float laplaceB = 0;
        laplaceB += b*-1;
        laplaceB += prev[i+1][j].b*0.2;
        laplaceB += prev[i-1][j].b*0.2;
        laplaceB += prev[i][j+1].b*0.2;
        laplaceB += prev[i][j-1].b*0.2;
        laplaceB += prev[i-1][j-1].b*0.05;
        laplaceB += prev[i+1][j-1].b*0.05;
        laplaceB += prev[i-1][j+1].b*0.05;
        laplaceB += prev[i+1][j+1].b*0.05;
  
        newspot.a = a + (dA*laplaceA - a*b*b + feed*(1-a))*1;
        newspot.b = b + (dB*laplaceB + a*b*b - (k+feed)*b)*1;
  
        newspot.a = constrain(newspot.a, 0, 1);
        newspot.b = constrain(newspot.b, 0, 1);
      }
    }
  }
  
  void swap() 
  {
    Cell[][] temp = prev;
    prev = grid;
    grid = temp;
  }
  float hue=0;
  float hue2=0;

  
    
       // color c = color(1/(a*255), 1/(b*255), (a-b)*255);
        //hue=hue+.1;
        //hue2=hue2+.3;
        //color c = color(hue, hue, (a-b)*255);
        
        //if(hue>255)
        //{
        //  hue=0;
        //}
        //if(hue2>255)
        //{
        //  hue2=0;
        //}
        
       // pixels[pos] = c;
        //println(1-(a*255));

  }
  
 
