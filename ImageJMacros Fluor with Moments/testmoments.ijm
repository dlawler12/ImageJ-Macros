range=3;
subfolder="edited";
drive="G:\\";
rename("edited");
setOption("BlackBackground", false);
run("Make Binary", "method=Moments background=Dark calculate");
run("Analyze Particles...", "size=1600-Infinity show=Masks clear stack");
run("Scale...", "x=.25 y=.25 z=1.0 width=256 height=256 depth=3 interpolation=Bilinear average process create title=[Mask of "+subfolder+"-1]");
if(nResults>2){
	val=getResult("Area",range-1);
	IJ.deleteRows(0, 2);
	threshold=val/500;
	threshold=threshold/16;
	run("Duplicate...", "title=Current duplicate range="+range);
	imageCalculator("Difference create stack", "Mask of "+subfolder+"-1","Current");
	selectWindow("Result of Mask of "+subfolder+"-1");
	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=5 fixed interpolate draw");
	run("Plot Z-axis Profile");
	holder=0;
	for(o=0; o<range; o++){
		value=getResult("Mean",o);
		if (value>threshold){
			holder=1;
		}
	}
	selectWindow("Result of Mask of edited-1-0-0");
	close();
	selectWindow("Result of Mask of edited-1");
	close();
	selectWindow("Current");
	close();
	selectWindow("Mask of edited-1");
	close();
	selectWindow("Mask of edited");
	close();
	selectWindow("edited");
	close();
	if (holder==1){
		return "Awake";
	}
	else{
		return "Sleep";
	}
}
else{
	selectWindow("Mask of edited-1");
	close();
	selectWindow("Mask of edited");
	close();
	selectWindow("edited");
	close();
	return "Awake";
}
