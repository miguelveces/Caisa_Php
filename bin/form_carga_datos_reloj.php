<?php

//$output_dir = "../../../../../tmp/";
$output_dir = "../Datareloj/";
 
if(isset($_FILES["myfile"]))
{
    //Filter the file types , if you want.
    if ($_FILES["myfile"]["error"] > 0)
    {
       //echo "Error: " . $_FILES["file"]["error"] . "<br>";
	   header('Content-type: application/json');
		$json = array("status" => 0);
		echo json_encode($json);
		exit();
    }
    else
    {
        if(!is_dir($output_dir)){
			mkdir($output_dir,0777,true);
		}
		
		//move the uploaded file to uploads folder;
        move_uploaded_file($_FILES["myfile"]["tmp_name"],$output_dir. $_FILES["myfile"]["name"]);
 
     //echo "Uploaded File :".$_FILES["myfile"]["name"];
	 header('Content-type: application/json');
	$json = array("status" => 1);
	echo json_encode($json);
	exit();
    }
 
}	

?>
