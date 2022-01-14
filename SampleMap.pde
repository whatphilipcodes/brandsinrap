//contains minium samplers, loads them and put them in a HashMap samples
public class SampleMap {
    
    private HashMap<String, Sampler> samples = new HashMap<String, Sampler>();
    private String samplesPath;
    private String[] sampleNames;
    
    SampleMap(int year, String[] brandNames) {    
        sampleNames = brandNames;
        //check if datapath exists
        samplesPath = dataPath("samples" + year + "/");
        File dir = new File(samplesPath);
        if (!dir.exists()) {
            System.out.println("sample directory missing for year: " + year);
            //System.exit(0);
        } else {
            //create samplers, load samples and put them in HashMap samples
            for (int i = 0; i < brandNames.length; i++) {
                String brandName = brandNames[i];
                String path = samplesPath + "/" + brandName + ".aif";
                if (!new File(path).exists()) {
                    System.out.println("sample missing for " + brandName);
                    //System.exit(0);
                } else {
                    samples.put(brandName, new Sampler(path, 1, minim));
                }
            }
            patchSamplers(samples);
        }
    }
    
    private void patchSamplers(HashMap<String, Sampler> smpls) {
        for (Sampler smplr : smpls.values()) {
            smplr.patch(out);
        }
    }
    
    //play sample 
    public void playSample(int brandNameIndex) {
        String brandName = sampleNames[brandNameIndex];
        if (samples.get(brandName) != null) {
            println("playing sample: " + brandName);
            samples.get(brandName).trigger();
        } else {
            //println("sample not found: " + brandName);
        }
    }
}

