<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";


//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data

}
else
{
  //Give it value at parameter 
	 $id_periodo = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	 $id_empresa = isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  ""; 	
	 $param = array('id_empresa' => $id_empresa,'id_periodo' => $id_periodo); 
	 $result = $client->call('GetInformeBankEmployeesByid',$param,'','','',true); 
	  header('Content-type: application/json');
	 $json = array("status" => 1,"info" => $result);
	 echo json_encode($json);
	 exit();
}


// fault if any
if ($client->fault) {
    echo 'Fault';
    print_r($result);
    echo '';
} 
else 
{
// Check for errors
    $err = $client->getError();
    if ($err) {
        // Display the error
        echo 'Error:'.$err;
    } 
	else 
	{
        // Display the result
        if($result!=false)
         {
		    header('Content-type: application/json');
			if($result[0]['id_cargo']==null)
			{
				$json = array("status" => 0, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 1, "info" => $result);
				
				
			}
			echo json_encode($json);
         }
    }
}		
?>