range=3;
subfolder="edited";
drive="G:\\";
rename("edited");
setOption("BlackBackground", false);
run("Make Binary", "method=Triangle background=Dark calculate");
run("Analyze Particles...", "size=100-Infinity show=Masks clear stack");
if(nResults>2){
range=3;
subfolder="edited";
drive="G:\\";
	val=getResult("Area",range-1);
	IJ.deleteRows(0, 2);
	//threshold=val/500;
	threshold=0.6;
	run("Duplicate...", "title=Current duplicate range="+range);
	imageCalculator("Difference create stack", subfolder,"Current");
	selectWindow("Result of "+subfolder);
	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=5 fixed interpolate draw");
	run("Plot Z-axis Profile");
	holder=0;
	for(o=0; o<range; o++){
		value=getResult("Mean",o);
		if (value>threshold){
			holder=1;
		}
	}
	selectWindow("Result of edited-0-0");
	close();
	selectWindow("Result of edited");
	close();
	selectWindow("Current");
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
	selectWindow("Mask of edited");
	close();
	selectWindow("edited");
	close();
	return "Awake";
}
