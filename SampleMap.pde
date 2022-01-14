//contains minium samplers, loads them, put them in a HashMap samples
public class SampleMap {
    
    private HashMap<String, Sampler> samples = new HashMap<String, Sampler>();
    private String samplesPath;
    private Sampler gucci;
    private Sampler louisvuitton;
    private Sampler ysl;
    private Sampler nike;
    private Sampler supreme;
        
    SampleMap(int year, String[] brandNames) {      
        
        //check if datapath exists
        samplesPath = dataPath("samples" + year + "/");
        File dir = new File(samplesPath);
        if (!dir.exists()) {
            System.out.println("sample directory missing for year: " + year);
            //System.exit(0);
        } else {
            //load all samples create samplers and push them in HashMap samples
            for (int i = 0; i < brandNames.length; i++) {
                String brandName = brandNames[i];
                String path = samplesPath + "/" + brandName + ".aif";
                samples.put(brandName, new Sampler(path, 1, minim));
            }
            patchSamplers(samples);
        }
    }
    
    private void patchSamplers(HashMap<String, Sampler> smpls) {
        for (Sampler smplr : smpls.values()) {
            smplr.patch(out);
        }
    }
    
}

