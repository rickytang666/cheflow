
void setup() {
  // URL for raw file access
  String fileUrl = "https://drive.google.com/uc?id=1NNGw9-YHL1edimNFApZlyfHyNtloxUEQ";
  
  // Load text from the file
  String[] warnings = loadStrings(fileUrl);
  
  // Print each line of the text file to the console
  for (String warning : warnings) {
    println(warning);
  }
}