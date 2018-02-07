By Lai Ding

//lif2tif      PC version.

//clear ImageJ window
run("Close All");

//user select .lif file, get total file count in .lif
run("Bio-Formats Macro Extensions");
file = File.openDialog("Choose a file");
Ext.setId(file);//-- Initializes the given id (filename).
Ext.getSeriesCount(seriesCount);//-- Gets the number of image series in the active dataset.
print(file);

var fileIndex;

// create folder with the same .lif name to store all individual tif images.
dir=substring(file, 0, lastIndexOf(file, "\\")+1);
folder_name=substring(file, lastIndexOf(file, "\\")+1, indexOf(file, ".lif") );
folder_name=replace(folder_name, " ", "_");
exec("cmd","/c","md", dir+folder_name);
dir=dir+folder_name+"\\";

// save each individual data set into Tiff in the subfolder folder_name
for(i=1;i<=seriesCount;i++)
 {
  run("Bio-Formats Importer", "open=["+file+"] color_mode=Default view=Hyperstack stack_order=XYCZT series_"+i);
  
  if( lastIndexOf(getTitle(), "Series") > 0 ) // Don't know what this does, but seems be be associated with "Series" in filename
   {
    filename=substring( getTitle(), lastIndexOf( getTitle(),"-")+2, lastIndexOf(getTitle(), "Series") );  // 
    print("a"+i);
    if( filename == "") // 
    filename=substring( getTitle(), lastIndexOf(getTitle(), "Series"), lengthOf(getTitle()));
print("b"+i);
   }
  else // Does not contain "Series" in filename, contains at least two files, if one file, errors in filename
    filename=substring( getTitle(), lastIndexOf( getTitle(),"-")+2, lengthOf(getTitle()) );  
      print("c"+i);
      print(filename);
  // replace any \ or / or space sign with _ in the filename
  filename=replace(filename, "\\", "_");
  filename=replace(filename, "/", "_");
  //filename=replace(filename, " ", "_");
  
  fileIndex=0;
  saveFile(filename);
  //print(dir+filename+".tif");
  //saveAs("Tiff", dir+filename+".tif");
  close();
 }

print("macro finishes");

// if files have same name, use "_x" (x as number) to indicate.
function saveFile(name)
 {
  if( File.exists(dir+name+".tif") != 1 )
   {
   	print(dir+name+".tif");
    saveAs("Tiff", dir+name+".tif");
   }
  else
   {
   	fileIndex++;
   	while( File.exists(dir+name+"_"+fileIndex+".tif") == 1 )
   	  fileIndex++;
    name=name+"_"+fileIndex;
    saveFile(name);
   }
 }
