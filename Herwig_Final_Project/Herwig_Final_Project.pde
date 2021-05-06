import KinectPV2.KJoint;
import KinectPV2.*;
import java.util.ArrayList;
import codeanticode.syphon.*;
SyphonServer server;
int vert1, vert2;
Limbtracker limbtracker;
Limbtracker limbtracker2;
Limbtracker limbtracker3;
Boolean[] zoneSetter=new Boolean[3];
KinectPV2 kinect;
float threshold=.5;
float zVal = 950;
float rotX = PI;
color col1=color(255,251,157,3);
//color col2=color(221,160,221);
color col2=color(0,0,255);
color col3=color(255,127,80,3);
Gradients gradient;
float quad1,quad2,quad3;
final int N = 128;
final int iter = 16;
final int SCALE = 4;
float t = 0;
//ParticleSystem ps;
Smoke smoke = new Smoke();
Smoke.ParticleSystem ps;
float dA = 1.0;
float dB = 0.3;
float feed = 0.052;
float k = 0.065;
Cell[][] grid;
Cell[][] prev;

//ReactionDiffusion react = new ReactionDiffusion();
//ReactionDiffusion.Cell cell;

Fluid fluid;

//void settings() {
// // size(N*SCALE, N*SCALE);
//}

void setup() {
    size(1920, 1080, P3D);
    fluid = new Fluid(0.2, 0, 0.0000001);
    colorMode(RGB);
    
    //kinect = new KinectPV2(this);
    
    server = new SyphonServer(this, "Processing Syphon");

    PImage img = loadImage("Texture.png"); 
    ps = smoke.new ParticleSystem(0, new PVector(width/2, height-60), img);

    
   // ps = new ParticleSystem(0, new PVector(width/2, height-60), img);
    
    //kinect.enableSkeletonColorMap(true);
    //kinect.enableColorImg(true);
    kinect.enableSkeleton3DMap(true);
    kinect.enableDepthMaskImg(true);
    //kinect.enableSkeletonDepthMap(true);
  
    kinect.init();
      
    vert1=width/3; 
    vert2=vert1*2;
    
    quad1=width/4;
    quad2=quad1*2;
    quad3=quad2+quad1;
    
    limbtracker= new Limbtracker(25);
    limbtracker2= new Limbtracker(25);
    limbtracker3= new Limbtracker(25);
    
    gradient=new Gradients();
    
    //Reaction Diffusion
    grid = new Cell[width][height];
    prev = new Cell[width][height];

      for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j ++) {
          float a = 1;
          float b = 0;
          grid[i][j] = new Cell(a, b);
          prev[i][j] = new Cell(a, b);
        }
      }
    
      for (int n = 0; n < 1; n++) {
        int startx = int(random(20, width-20));
        int starty = int(random(20, height-20));
    
        for (int i = startx; i < startx+10; i++) {
          for (int j = starty; j < starty+10; j ++) {
            float a = 1;
            float b = 1;
            grid[i][j] = new Cell(a, b);
            prev[i][j] = new Cell(a, b);
          }
        }
      }
     
}

void draw() {
  
  //Image being grabbed from kinect
  //image(kinect.getColorImage(), 0, 0, width, height);
  //pushMatrix();
  //scale(3.8);
  //image(kinect.getDepthMaskImage(), 0, 0);
  //popMatrix();

  //lines in thirds for debugging
  //line(vert1,height,vert1,0);
  //line(vert2,height,vert2,0);

  //Thirds
  //gradient.linear(0,vert1,height*2, col1, col3); 
  //gradient.linear(vert1,vert2,height*2, col3, col1); 
  //gradient.linear(vert2,width*2,height*2, col1, col3);
  
  //Quads
  //gradient.linear(0,quad1,height*2, col1, col3); 
  //gradient.linear(quad1,quad2,height*2, col3, col1); 
  //gradient.linear(quad2,quad3,height*2, col1, col3); 
  //gradient.linear(quad3,width,height*2, col3, col1);

  //Single Quad
  //gradient.quad(width*2,height*2,col1,col3,col1,col1);
  
  //Radial gradient
  gradient.radial(width*3,height*3,col1,col3,100);

  pushMatrix();
  pushStyle();
  stroke(0,0,255);
  translate(width/2, height/2, 0);
  scale(zVal);
  rotateX(rotX);
  SkullyBoi();
  popStyle();
  popMatrix();
  
  //Reaction Diffusion
  for (int i = 0; i < 1; i++) 
  {
    update();
    swap();
  }

  loadPixels();
  for (int i = 1; i < width-1; i++) {
    for (int j = 1; j < height-1; j ++) {
      Cell spot = grid[i][j];
      float a = spot.a;
      float b = spot.b;
      int pos = i + j * width;
     
      pixels[pos] = color((a-b)*255);
      
    }
  }
  updatePixels();
  
//SMOKE  
  // Calculate a "wind" force based on mouse horizontal position
  //float dx = map(mouseX, 0, width, -0.2, 0.2);
  //PVector wind = new PVector(dx, 0);
  //ps.applyForce(wind);
  //ps.run();
  //for (int i = 0; i < 2; i++) {
  //  ps.addParticle();
  //}

  //FLUID
  // Draw an arrow representing the wind force
  //drawVector(wind, new PVector(width/2, 50, 0), 500);
  
  //int cx = int(0.5*width/SCALE);
  //int cy = int(0.5*height/SCALE);
  //for (int i = -1; i <= 1; i++) {
  //  for (int j = -1; j <= 1; j++) {
  //    fluid.addDensity(cx+i, cy+j, random(50, 150));
  //  }
  //}
  //for (int i = 0; i < 2; i++) {
  //  float angle = noise(t) * TWO_PI * 2;
  //  PVector v = PVector.fromAngle(angle);
  //  v.mult(0.2);
  //  t += 0.01;
  //  fluid.addVelocity(cx, cy, v.x, v.y );
  //}


  //fluid.step();
  //fluid.renderD();
  //fluid.renderV();
  //fluid.fadeD();
  
  server.sendScreen();

    //fill(0, 0, 0);
    //text(frameRate, 50, 50);
}

void SkullyBoi()
{
  // setNonActive();  
   ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();   
   //ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();  
  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      float xSetter=getJointX(joints,KinectPV2.JointType_SpineMid);
       // println(xSetter);    
       //println(zoneSetter);       
                          
             zoneSetter[2]=true;    
              
             //drawTriangleBoi(joints);
             limbtracker.update2(joints);
             //filling second PVector with the first PVectors values
             limbtracker.fillFollowing(KinectPV2.JointType_Count);       
             float[] comparison=limbtracker.distance(KinectPV2.JointType_Count);
             limbtracker.fillBuffer(comparison);
             
              if (limbtracker.limbActivated(KinectPV2.JointType_HandLeft)) 
              {              

              }
              
              if(limbtracker.limbFlailing(KinectPV2.JointType_HandLeft))
              {
 
              } 
              
              else
              {

              }
                
              if (limbtracker.limbActivated(KinectPV2.JointType_HandRight)) 
              {            

                              
              }
              
              if (limbtracker.limbActivated(KinectPV2.JointType_KneeRight)) 
              {      

              }
                    
              if (limbtracker.limbActivated(KinectPV2.JointType_KneeLeft)) 
              {  
                
              }
              
      }
  }
  
}

//void setNonActive()
//{
//  for (int j=0; j<zoneSetter.length; j++)
//       {
//         zoneSetter[j]=false;
//       }       
//       for (int j=0; j<zoneSetter.length; j++)
//       {
//         if (zoneSetter[2]==false)
//         {     
       
//         }         
        
//         if (zoneSetter[1]==false)
//         {           

//         }  
           
//         if (zoneSetter[0]==false)
//         {
       
//         }           
//       }  
//}


//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

  
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
  
  
  //float hue=0;
  //float hue2=0;

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

  

//draw joint
//void drawJoint(KJoint[] joints, int jointType) {
//  pushMatrix();
//  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
//  ellipse(0, 0, 25, 25);
//  popMatrix();
//}

////draw bone
//void drawBone(KJoint[] joints, int jointType1, int jointType2) {
//  pushMatrix();
//  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
//  ellipse(0, 0, 25, 25);
//  popMatrix();
//  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
//}


void drawJoint(KJoint[] joints, int jointType) {
  //strokeWeight(2.0f + joints[jointType].getZ()*8);
  pushStyle();
  strokeWeight(.05);   
  popStyle();
  //float xMapped = map(joints[jointType].getX(), -1.28, 1, 0, width);
  //float yMapped = map(joints[jointType].getY(), -0.3, 0.07, 0, height);
  //float zMapped = map(joints[jointType].getZ(), 1, 8, 0, height*2);
  //point(xMapped, yMapped, zMapped);
  //println(xMapped);
  point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
}

void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  //strokeWeight(2.0f + joints[jointType1].getZ()*8);
  
  //float xMapped = map(joints[jointType1].getX(), -1.28, 1, 0, width);
  //float yMapped = map(joints[jointType1].getY(), -0.3, 0.07, 0, height);
  //float zMapped = map(joints[jointType1].getZ(), 1, 8, 0, height*2);
  pushStyle();
  strokeWeight(.01);  
  popStyle(); 
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(),joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
    
}

//Gets an X value of a joint.
float getJointX(KJoint[] joints, int jointType)
{
    return (joints[jointType].getX());
}
