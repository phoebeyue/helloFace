public class OSCHandler {
    private PApplet papplet = null;
    private OscP5 oscP5 = null;
    private int localOscPort = 12000;
    private NetAddress myRemoteLocation = null;
    private String remoteAddress = "127.0.0.1";    //default address is local
    private int remoteOscPort = 12001;



    public OSCHandler(PApplet papplet, int localOscPort, String remoteAddress, int remoteOscPort){
        this.papplet = papplet;
        this.localOscPort = localOscPort;
        this.remoteAddress = remoteAddress;
        this.remoteOscPort = remoteOscPort;
        
        oscP5 = new OscP5(papplet, localOscPort);
        myRemoteLocation = new NetAddress(remoteAddress, remoteOscPort);
        
        //add plugs (plug to this object's function!) for receive OSC message from outside
        oscP5.plug(this, "queryCamRes", "/queryCamRes");    //query for camera's resolution (camera's width and height)
        oscP5.plug(this, "queryCamFps", "/queryCamFps");    //query for camera's FPS
        //others add here ...
    }
    

    //this function can be extended for send out other detecting results
    public void sendOut(Rectangle[] faceRect){
        //send out face-detecting result
        if(faceRect!=null && faceRect.length>0){
            OscMessage myMessage = new OscMessage("/faceDetect");
            myMessage.add(faceRect.length);    //偵測到的face數量
            
            //集合偵測到的人臉資訊
            String facelist = "";
            for(int i=0; i<faceRect.length; i++){
                //normalizing values
                float x = faceRect[i].x/float(camProperties.getCamWidth());
                float y = faceRect[i].y/float(camProperties.getCamHeight());
                float w = faceRect[i].width/float(camProperties.getCamWidth());
                float h = faceRect[i].height/float(camProperties.getCamHeight());
                facelist = facelist + "x=" + x + ",y=" + y + ",w=" + w + ",h=" + h;
                if(i < faceRect.length-1){
                    facelist = facelist + "|";
                }
            }

            //println("[OSC out] /faceDetect "+ faceRect.length +" " + facelist);            
            myMessage.add(facelist);    //偵測到的face矩型數據串
            oscP5.send(myMessage, myRemoteLocation); 
        }
    }
    
    
    public int getLocalOscPort(){
        return localOscPort;
    }
    public String getRemoteAddress(){
        return remoteAddress;
    }
    public int getRemoteOscPort(){
        return remoteOscPort;
    }
    
    //stop oscP5 and close open Sockets.    (避免重啟oscP5時佔用相同的local port)
    public void stop(){
        if(oscP5 != null)    oscP5.stop();
    }
    

    /*following methods are for responding to coming OSC from outside*/

    //query for camera's resolution (camera's width and height)
    public void queryCamRes() {
        //return camera resolution
        OscMessage myMessage = new OscMessage("/returnCamRes");
        myMessage.add(camProperties.getCamWidth());
        myMessage.add(camProperties.getCamHeight());
        oscP5.send(myMessage, myRemoteLocation); 
    }
    
    //query for camera's FPS 
    public void queryCamFps() {
        //return camera FPS
        OscMessage myMessage = new OscMessage("/returnCamFps");
        myMessage.add(camProperties.getCamFPS());
        oscP5.send(myMessage, myRemoteLocation); 
    }

    //other responding methods add here ...
}
