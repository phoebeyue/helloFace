public class SettingPanel {
    private PApplet papplet = null;
    private int width = 100;            //width of panel
    private boolean isSettingMode = false;
    
    //controlP5 controllers
    private ControlP5 cp5;
    private DropdownList dropdownList;
    
    
    public SettingPanel(PApplet papplet, int width){
        this.papplet = papplet;
        this.width = width;
        
        //controllers
        cp5 = new ControlP5(papplet);
        setControllers();
    }
    
    public void switchOnOff(){
        //展開setting panel
        if(!isSettingMode){
            papplet.frame.setSize(viewPanelWidth+width, viewPanelHeight);
            isSettingMode = true;
        }else{    //縮回setting panel
            papplet.frame.setSize(viewPanelWidth, viewPanelHeight);
            isSettingMode = false;
        }
    }
    
    
    private void setControllers(){
        /*DropdownList for camera list*/
        dropdownList = cp5.addDropdownList("cameraList")
                               .setSize(250, 100)
                               .setPosition(viewPanelWidth+50, 50)
                               .setBackgroundColor(color(190))
                               .setColorBackground(color(60))
                               .setColorActive(color(255, 128))
                               .setItemHeight(25)
                               .setBarHeight(20)
                               .setScrollbarWidth(10);
        dropdownList.captionLabel().set("camera list");
        dropdownList.captionLabel().style().marginTop = 5;
        dropdownList.captionLabel().style().marginLeft = 5;
        dropdownList.valueLabel().style().marginTop = 5;
        //add camera list items
        String[] cams = camProperties.getAvailableList();
        if(cams != null){
            for(int i=0; i<cams.length; i++){
                dropdownList.addItem(cams[i], i);
            }
        }
    }
}
