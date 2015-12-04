Dialog.create("Specifications");

//Creation of File : Input full location of the file (including root directory)

  FileLocation="E:\\[filename].avi";
  Dialog.addString("File Location:",FileLocation);

//Specifications for Image Processing : input the number of images to analyze
Dialog.addNumber("images:", 0);
Dialog.show();
FileLocation = Dialog.getString();
images = Dialog.getNumber();

// Correct for image shifting
run("AVI...", "select="+FileLocation+" first=1 last="+images+" convert");
rename("Original");
run("Duplicate...", "title=Threshold duplicate range=1-nSlices");
selectWindow("Threshold");
run("Make Binary", "method=Default background=Default calculate");
run("Set Measurements...", "area mean min center median stack redirect=None decimal=3");

allX=0;
allY=0;
for (x=500; x<6000; x=x+1000){
	for (y=500; y<4000; y=y+1000){
		run("Clear Results");
		makeRectangle(x,y, 250, 250);
		run("Measure");
		allX=allX+getResult("XM",0);
		allY=allY+getResult("YM",0);
	}
}
allX=allX/24;
allY=allY/24;

for (i=2; i<nSlices+1; i++){
	selectWindow("Threshold");
	setSlice(i);
	newX=0;
	newY=0;
	for (x=500; x<6000; x=x+1000){
		for (y=500; y<4000; y=y+1000){
			run("Clear Results");
			makeRectangle(x,y, 250, 250);
			run("Measure");
			newX=newX+getResult("XM",0);
			newY=newY+getResult("YM",0);
		}
	}
	newX=newX/24;
	newY=newY/24;

	selectWindow("Original");
	setSlice(i);
	run("Select All");
	run("Copy");
	Roi.move(round(allX-newX),round(allY-newY));
	run("Paste");
}

// Find movement by adjacent frame subtraction
selectWindow("Threshold");
run("Select All");
run("Duplicate...", "title=Thresh duplicate range=1-1");
selectWindow("Threshold");
close();
selectWindow("Thresh");
rename("Threshold");
selectWindow("Original");
run("Duplicate...", "title=backend duplicate range=2-"+nSlices);
selectWindow("Original");
setSlice(nSlices);
run("Delete Slice");
imageCalculator("Difference create stack", "Original", "backend");
rename("Diff");

// Find average intensity of subtracted frames
run("Z Project...", "projection=[Average Intensity]");
selectWindow("AVG_Diff");
selectWindow("Original");
close();
selectWindow("backend");
close();
selectWindow("Diff");
close();
cellnum=0;
array=newArray(384);

// Find movement for each well centered around proper area
for (xstart=0; xstart<6000; xstart=xstart+250){
	for (ystart=0; ystart<4000; ystart=ystart+250){
		selectWindow("Threshold");
		run("Clear Results");
		makeRectangle(xstart,ystart,250,250);
		run("Measure");
		CenterX=getResult("XM",0);
		CenterY=getResult("YM",0);
		newX=round(CenterX-62.5);
		newY=round(CenterY-62.5);
		selectWindow("AVG_Diff");
		makeRectangle(newX,newY,125,125);
		run("Clear Results");
		run("Measure");
		array[cellnum]=getResult("Mean",0);
		cellnum++;
	}
}
Array.show(array);
