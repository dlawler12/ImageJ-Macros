beginning = drive+root+"\\";
firstimage = "\\"+firstimage+".tif";
file=beginning+subfolder+firstimage;
holder=0;
value=0;
run("Image Sequence...", "open="+file+" number="+range+" starting="+i-1+" scale=25 sort");
setOption("BlackBackground", false);
run("Make Binary", "method=Triangle background=Dark calculate");
run("Dilate", "stack");
run("Analyze Particles...", "size=100-Infinity show=Masks display clear stack");
val=getResult("Area",range-1);
//threshold=val/470;
threshold=0.9;
run("Duplicate...", "title=Current duplicate range="+range);
imageCalculator("Difference create stack", subfolder,"Current");
selectWindow("Result of "+subfolder);
run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=5 fixed interpolate draw");
run("Plot Z-axis Profile");
for(o=0; o<range; o++){
	value=getResult("Mean",o);
	if (value>threshold){
		holder=1;
	}
}
if (holder==1){
	open(drive+"AwakeText.tif");
}
else{
	open(drive+"SleepText.tif");
}
holder=0;
