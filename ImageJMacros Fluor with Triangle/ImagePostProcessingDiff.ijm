Dialog.create("Specifications");


//Creation of File 
  drive="drive";
  Dialog.addChoice("drive:", newArray("A:\\","B:\\","C:\\","D:\\","E:\\","F:\\","G:\\","H:\\","I:\\","J:\\","K:\\","L:\\","M:\\","N:\\","O:\\","P:\\","Q:\\","R:\\","S:\\","T:\\","U:\\","V:\\","W:\\","X:\\","Y:\\","Z:\\"));
 
  root="word1";
  Dialog.addString("root:", root);  

  subfolder= "word2";  
  Dialog.addString("Subfolder:", subfolder);

  firstimage="word3";
  Dialog.addString("first image:",firstimage);

  file = drive+root+"\\"+subfolder+"\\"+firstimage;

//Specifications for Image Processing

  start=0; images =0;
  Dialog.addNumber("start:", 1);
  Dialog.addNumber("images:", 0);
  
  deltaT=0;
  range=0;
  increment=0;
  threshold=0;

  Dialog.addNumber("deltaT:", 0);
  Dialog.addNumber("range:", 0);
  Dialog.addNumber("increment:", 0);
  Dialog.addNumber("threshold:", 0);
 
  Dialog.show();


  drive = Dialog.getChoice();
  root = Dialog.getString();
  subfolder = Dialog.getString();
  firstimage= Dialog.getString();
  start = Dialog.getNumber();
  images = Dialog.getNumber();
  deltaT = Dialog.getNumber();
  range = Dialog.getNumber();
  increment = Dialog.getNumber();
  threshold = Dialog.getNumber();
  beginning = drive+root+"\\";
  firstimage = "\\"+firstimage+".tif";
  file=beginning+subfolder+firstimage;

/*
//Original entry system

start=1; //starting frame (consider increment)
images=340; //Total # of frames imported
beginning="E:\\061015\\"; //Root folder
subfolder="Individual"; //Folder files are saved in
firstimage="\\061015_0000.tif"; //name of first image
file=beginning+subfolder+firstimage; //Combine folder names
deltaT=18; //Timeframe of analysis
range=5; // # of points for thresholding
increment=10; //increment between frames
threshold=2; //threshold cut off
*/
holder=0;
value=0;
array=newArray(images);
for (i=start; i<(images+start); i++) {
	run("Image Sequence...", "open="+file+" number="+deltaT+" starting="+(i*increment-(increment-1))+" increment="+increment+" scale=25 sort");
	setOption("BlackBackground", false);
	run("Make Binary", "method=Triangle background=Dark calculate");
	//run("Dilate", "stack");
	run("Analyze Particles...", "size=100-Infinity show=Masks clear stack");
	run("Duplicate...", "title=Current duplicate range="+deltaT);
	imageCalculator("Difference create stack", subfolder,"Current");
	selectWindow("Result of "+subfolder);
	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=5 fixed interpolate draw");
	run("Plot Z-axis Profile");
	value=getResult("Mean",0); //first value
	array[i-start]=value;
	run("Close All");

}
Array.show(array);
