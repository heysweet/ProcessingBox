class Particle {
  private Point position, velocity, acceleration;
  private float particleWidth;
  private int lifespan;
  private float r, g, b;
  private boolean isRed;
  private float angle, deltaAngle;

  Particle(Point p, Point v, Point a, float w, int l) {
    this.position = p;
    this.velocity = v;
    this.acceleration = a;
    this.particleWidth = w;
    this.lifespan = l;


    this.r = random(255);
    this.g = random(255);
    this.b = random(255);
    float redPercentage = 0.0f;
    this.angle = random(0,1);
    deltaAngle = random(-0.05f, 0.05f);

    isRed = false;
    if(random(0,1) < redPercentage)
      isRed = true;
  }

  public boolean isAlive() { return lifespan != 0; }

  // Method to update location
  public void update() 
  {
    // euler integration
    velocity.x += acceleration.x; 
    velocity.y += acceleration.y;
    position.x += velocity.x;
    position.y += velocity.y;
    angle += deltaAngle;

    lifespan -= 1;
    if(lifespan == 0)
      particleWidth *= 1.1f;
  }

  // Method to display
  public void draw() {

    if(this.isAlive())
      this.update();

    if(isRed)
      fill(255,0,0);
    else
      fill(r, g, b);
    
    pushMatrix();
      translate(position.x,position.y);
      rotate(angle);
      rect(0f, 0f, particleWidth, particleWidth);
    popMatrix();
    
  }
}



// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  public Point source, target;
  float particleWidth;
  int leftToGenCount;

  /*
    source: source of target 
    target: target point of the particle
    w: width of each particle
    c: number of particles of emit
    
  */
  ParticleSystem(Point source, Point target, float w, int c) {
    this.source = source;
    this.target = target;
    this.particleWidth = w;
    this.leftToGenCount = c;

    particles = new ArrayList<Particle>();
    particleWidth = w;
  }


  public void setTarget(Point t)
  {
    target = t;
  }


  public void update()
  {
    if(leftToGenCount > 0)
    {
      float dx = target.x - source.x;
      float dy = target.y - source.y;
      float distance = dx*dx + dy*dy;
      dx = dx/sqrt(distance) + random(-0.1,0.1);
      dy = dy/sqrt(distance) + random(-0.1,0.1);
      float dvx = random(-0.01f, 0.01f);
      float dvy = random(-0.01f, 0.01f);
      particles.add(new Particle(new Point(source.x, source.y), 
                                 new Point(2f*dx,2f*dy), 
                                 new Point(dvx, dvy), 
                                 particleWidth + random(-particleWidth/30f, particleWidth/30f), 
                                 100+(int)random(-50,200)));
      leftToGenCount--;
    }
  }

  public void draw() {

    this.update();
    noStroke();

    for (int i = 0; i < particles.size(); i++) 
    {
      particles.get(i).draw();
    }
  }
}
