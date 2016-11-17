<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultDiscountsIncome="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "GET"){
    // Get data      
  
     $id_empleado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
    //Give it value at parameter 
    $param = array('id_empleado' => $id_empleado); 
	$result = $client->call('GetAllDiscountsIncomeEmployeeByidEmployee',$param,'','','',true);
	$resultDiscountsIncome = $client->call('GetAllDiscountsIncome',$param,'','','',true);
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
			if($result[0]['id_descuento_ingreso_empleado']==null)
			{
				$json = array("status" => 0, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 1, "info" => $result, "discountsincome"=> $resultDiscountsIncome);
				
				
			}
			echo json_encode($json);
         }
    }
}		
?>