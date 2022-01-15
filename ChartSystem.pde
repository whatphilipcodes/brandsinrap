// System that manages indiviual bar masks

class ChartSystem {
    //Local object variabes
    ArrayList<RectBarChart> charts;
    
    PVector currentOr;
    boolean[] status;
    PVector growth;
    boolean isY;
    int timer;
    int chartSystemYear;
    private SampleMap samplesMap;  
    private String[] brandNames;
    
    int chartIndex = 0;
    
    //Constructor
    ChartSystem(int x, int y) {
        charts = new ArrayList<RectBarChart>();
        chartSystemYear = startYear + systemIteration;
        brandNames = loadData((chartSystemYear), 5);
        samplesMap = new SampleMap(chartSystemYear, brandNames);
        status = new boolean[propData.length];
        currentOr = new PVector(x, y);
        growth = new PVector(0, 0);
        animDone = false;
        isY = initIsY();
        
        // Glitch stored images
        for (int i = 0; i < brandImg.length; i++) {
            brandImg[i].resize(width, height);
            initializePGraphicsImage(glitchPGs[i], brandImg[i]);
        }
        timer = millis();
    }
    
    //load an image into PGraphics layer and distort it
    void initializePGraphicsImage(PGraphics pg, PImage pi) {
        pg.beginDraw();
        pg.background(0);
        pg.image(pi, 0, 0, width, height);
        glitch(pg);
        pg.endDraw();
    }
    
    // distort the image in the PGraphicslayer 
    void glitch(PGraphics pg) {
        int glitchCount = 0;
        if (glitchCount < glitchIterations) {
            for (int i = 0; i < glitchAmount; ++i) {
                //source
                int x1 = (int) random(0, width);
                int y1 = (int) random(0, height);
                //destination
                int x2 = round(x1 + random( -glitchIntensity, glitchIntensity));
                int y2 = round(y1 + random( -glitchIntensity, glitchIntensity));
                //sizeofcopyblock
                int w = round(random(50, 100));
                int h = round(random(50, 100));
                pg.copy(x1, y1, w, h, x2, y2, w, h);
            }
            glitchCount++;
        }
    }
    
    //Runs the animation; this needs to sit in the draw() loop
    void run() {
        //println("millis() > timer + chartIndex * barDelay "+ timer + chartIndex * barDelay);
        if ((chartIndex < propData.length) && (millis() > timer + chartIndex * barDelay)) {
            systems.get(0).addBar();
        }
        
        for (int i = 0; i < charts.size(); i++) {
            if (status[i] == false) {
                RectBarChart rbc = charts.get(i);
                status[i] = rbc.morph(animSpeed, 0.99);
                //play sample
                if (rbc.played == false) {
                    samplesMap.playSample(i);
                    rbc.played = true;
                }
                
                rbc.createMaskShape(maskPGs[i]);
                glitchPGs[i].mask(maskPGs[i]);
                image(glitchPGs[i], 0, 0);
                
            }
        }
        animDone = checkStatus();
    }
    
    //Creates new RectBarChart object
    void addBar() {
        charts.add(new RectBarChart(currentOr, isY, chartIndex, growth));
        RectBarChart rbc = charts.get(chartIndex);
        rbc.initCoords();
        growth.add(rbc.targetCoords());
        currentOr = rbc.newOrigin();
        chartIndex++;
        isY = !isY;
    }
    
    boolean checkStatus() {
        for (int i = 0; i < status.length; ++i) {
            boolean b = status[i];
            if (!b) return false;
        }
        return true;
    }
}
