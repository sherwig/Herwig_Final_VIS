public class Gradients {
    
  public void linear( float startX,float endX, float height, color colorStart, color colorStop)
  {
    pushMatrix();
    
    float halfW = (endX+startX)/2;
    float halfH = height/2;
    
    beginShape();
    noStroke();
    fill(colorStart);
    vertex(startX, -halfH);
    fill(colorStop);
    vertex(endX, -halfH);
    fill(colorStop);
    vertex(endX, halfH);
    fill(colorStart);
    vertex(startX, halfH);
    println(halfW); 
    endShape(CLOSE);
       
    //beginShape();
    //fill(colorStart);
    //vertex(-halfW, -halfH);
    //fill(colorStop);
    //vertex(halfW, -halfH);
    //fill(colorStop);
    //vertex(halfW, halfH);
    //fill(colorStart);
    //vertex(-halfW, halfH);
    //println(halfW); 
    //endShape(CLOSE);
    
    popMatrix();
  }
    
  public void quad( float width, float height, color colorTL, color colorTR, color colorBR, color colorBL )
  {
    pushMatrix();
    
    float halfW = width/2;
    float halfH = height/2;
    
    beginShape();
    fill(colorTL);
    vertex(-halfW, -halfH);
    fill(colorTR);
    vertex(halfW, -halfH);
    fill(colorBR);
    vertex(halfW, halfH);
    fill(colorBL);
    vertex(-halfW, halfH);
    endShape(CLOSE);
    
    popMatrix();
  }
  
  
  public void radial( float width, float height, color colorInner, color colorOuter, int numSegments )
  {
    pushMatrix();

    float halfW = width/2;
    float halfH = height/2;
    
    float segmentRadians = TWO_PI / numSegments;
    noStroke();
    for(float r=0; r < TWO_PI; r += segmentRadians) {
      float r2 = r + segmentRadians;
      beginShape();
      fill(colorInner);
      vertex(0,0);
      fill(colorOuter);
      vertex(sin(r) * halfW, cos(r) * halfH);
      vertex(sin(r2) * halfW, cos(r2) * halfH);
      endShape(CLOSE);
    }
    
    popMatrix();
  }
  
}
