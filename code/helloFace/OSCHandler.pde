public class OSCHandler {
    private PApplet papplet = null;
    private OscP5 oscP5 = null;
    private int localOscPort = 12000;
    private NetAddress myRemoteLocation = null;
    private String remoteAddress = "127.0.0.1";    //default address is local
    private int remoteOscPort = 12001;



    public OSCHandler(PApplet papplet){
        this.papplet = papplet;
        oscP5 = new OscP5(papplet, localOscPort);
        myRemoteLocation = new NetAddress(remoteAddress, remoteOscPort);
        
        //add plugs (plug to this object's function!)
        oscP5.plug(this, "test", "/test");
    }
    

    public void sendOut(Rectangle[] faceRect){
        if(faceRect!=null && faceRect.length>0){
            OscMessage myMessage = new OscMessage("/faceDetect");
            myMessage.add(faceRect.length);    //偵測到的face數量
            
            //集合偵測到的人臉資訊
            String facelist = "";
            for(int i=0; i<faceRect.length; i++){
                facelist = facelist + "x=" +faceRect[i].x + ",y=" + faceRect[i].y + ",w=" + faceRect[i].width + ",h=" + faceRect[i].height;
                if(i < faceRect.length-1){
                    facelist = facelist + "|";
                }
            }
            
            myMessage.add(facelist);    //偵測到的face矩型數據串
            oscP5.send(myMessage, myRemoteLocation); 
        }
    }
    

    public void test(int theA, int theB) {
        println("### plug event method. received a message /test.");
        println(" 2 ints received: "+theA+", "+theB);  
    }
}
