range=3;
subfolder="edited";
drive="G:\\";
rename("edited");
setOption("BlackBackground", false);
run("Make Binary", "method=Moments background=Light calculate");
run("Analyze Particles...", "size=250-1500 display stack");	
if(nResults>2){
	run("Duplicate...", "title=Current duplicate range="+range);
	imageCalculator("Difference create stack", subfolder,"Current");
	selectWindow("Result of "+subfolder);
	run("Clear Results");
	run("Analyze Particles...", "size=20-Infinity show=Masks clear stack");
	//val=getResult("Area",range-1);
	run("Clear Results");
	threshold=1;
	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=5 fixed interpolate draw");
	run("Plot Z-axis Profile");
	holder=0;
for(o=0; o<range; o++){
	value=getResult("Mean",o);
	if (value>threshold){
		holder=1;
	}
}
selectWindow("Mask of Result of edited");
close();
selectWindow("Mask of Result of edited-0-0");
close();
selectWindow("Result of edited");
close();
selectWindow("Current");
close();
//selectWindow("Mask of edited");
//close();
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
	//selectWindow("Mask of edited");
	//close();
	selectWindow("edited");
	close();
	return "Awake";
}
