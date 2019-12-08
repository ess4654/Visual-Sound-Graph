import ddf.minim.*;

float maxAmp = 0.7; //Set Low for max results, Set High for low results
int bars = 8; //Use 8 for best result
int barHeight = 20; //Use 20 for best result
int h, w, stroke;
int frames, sampleRate;
boolean map[][];

Minim minim;
AudioPlayer player;
 
void setup()
{
  fullScreen(P2D);
  //size(1280, 720, P2D);
  
  frames = 0;
  sampleRate = 1; //Number of frames skipped
  map = new boolean[bars][barHeight];
  h = height / barHeight;
  w = width / bars;
  stroke = min((int) (-0.42 * barHeight + 25), (int) (-6.059 * log(bars) + 28.2));
  
  minim = new Minim(this);
  player = minim.loadFile("/data/Coding Track - 02.mp3");
  player.play();
}

void draw()
{
  if(frames%sampleRate == 0) {
    background(0);
    //Set far right bar
    map[bars - 1] = new boolean[barHeight];
    map[bars - 2] = new boolean[barHeight];
    float amp = (player.left.level() + player.right.level()) / 2;
    for(int w = barHeight - 1;
        w >= (((barHeight - (amp / (maxAmp / barHeight))) < 0) ? 0 :
        (barHeight - (amp / (maxAmp / barHeight))));
        w--)
      map[bars - 1][w] = map[bars - 2][w] = true;
    
    //Transition Bars
    for(int z = 0; z < bars - 2; z++) {
      for(int y = 0; y < barHeight; y++) {
        map[z][y] = map[z+1][y];
      }
    }
    
    //Draw bars
    stroke(0);
    strokeWeight(stroke);
    for(int i = 0; i < bars; ++i) {
      for(int j = 0; j < barHeight; ++j) {
        fill((barHeight - j) * (255/barHeight), j * (255/barHeight), 0);
        if(map[i][j] && i != bars - 3){
          rect((w * i), (h * j), w, h, stroke);
        }
      }
    }
  }
  frames++;
}
