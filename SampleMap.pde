//contains minium samplers, loads them, put them in HashMap
class SampleMap {
  private HashMap<String, Sampler> samples = new HashMap<String, Sampler>();
  private String samplesPath;
  private Sampler gucci;
  private Sampler louisvuitton;
  private Sampler ysl;
  private Sampler nike;
  private Sampler supreme;

  SampleMap(String year) {
    samplesPath = dataPath(year) + "/";
    //println(samplesPath);

    gucci = new Sampler(samplesPath + "gucci" + ".aif", 1, minim);
    supreme = new Sampler(samplesPath + "supreme.aif", 1, minim);
    louisvuitton = new Sampler(samplesPath + "louis vuitton.aif", 1, minim);
    ysl = new Sampler(samplesPath + "ysl.aif", 1, minim);
    nike = new Sampler(samplesPath + "nike.aif", 1, minim);

    samples.put("gucci", gucci);
    samples.put("supreme", supreme);
    samples.put("louis vuitton", louisvuitton);
    samples.put("yves saint laurent", ysl);
    samples.put("nike", nike);
    
    patchSamplers(samples);
  }
  
  private void patchSamplers(HashMap<String, Sampler> smpls) {
    for (Sampler smplr : smpls.values()) {
      smplr.patch(out);
    }
}
    
}
