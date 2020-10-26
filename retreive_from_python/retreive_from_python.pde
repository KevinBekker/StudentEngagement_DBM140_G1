import processing.net.*; 
Client myClient;
String dataIn;
int test = 1;
void setup() { 
  size(200, 200); 
  /* Connect to the local machine at port 50007
   *  (or whichever port you choose to run the
   *  server on).
   * This example will not run if you haven't
   *  previously started a server on this port.
   */
  myClient = new Client(this, "127.0.0.1", 50002);
  print("Test");
} 

void draw() { 
  myClient.write(test);
  if(myClient.available() > 0) {
      println(myClient.readString());
  }
  test++;
} 
