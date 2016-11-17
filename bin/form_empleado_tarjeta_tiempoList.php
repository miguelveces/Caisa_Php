<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
//Give it value at parameter 
    $id_empresa = isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  "";
	$param = array('id_empresa' => $id_empresa); 
	$result = $client->call('GetEmployeeByidCompany',$param,'','','',true);

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
			if($result[0]['id_empleado']==null)
			{
				$json = array("status" => 0, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 1, "info" => $result);
				
				//header('Location: ../form_inicio.html');	
			}
			echo json_encode($json);
         }
    }
}		
?>