<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){

     
}
else
{

    $param = array(); 
	$result = $client->call('GetPeriodByStatus',$param,'','','',true);
	 /*$_SESSION['id_periodo']=$result[0]['id_periodo'];
	 $_SESSION['numero_periodo']=$result[0]['numero_periodo'];
	 $_SESSION['fecha_desde']=$result[0]['fecha_desde'];
	 $_SESSION['fecha_hasta']=$result[0]['fecha_hasta'];*/
	 

					
    header('Content-type: application/json');
	 $json = array("status" => 1, "info" => $result);
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
			if($result[0]['msg']!='OK')
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