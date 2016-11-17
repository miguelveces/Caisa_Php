<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";

$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data      
        $cod_descuento_ingreso = isset($_POST['coddesingre']) ? mysqli_real_escape_string($connect, $_POST['coddesingre']) :  "";
	$nombre_descuento_ingreso = isset($_POST['namedesingre']) ? mysqli_real_escape_string($connect, $_POST['namedesingre']) :  "";
	$tipo = isset($_POST['typedesingre']) ? mysqli_real_escape_string($connect, $_POST['typedesingre']) :  "";
	$numero_cuenta = isset($_POST['numbank']) ? mysqli_real_escape_string($connect, $_POST['numbank']) :  "";
    $id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
    //Give it value at parameter 
    $param = array('cod_descuento_ingreso' => $cod_descuento_ingreso,'nombre_descuento_ingreso' => $nombre_descuento_ingreso,'tipo' => $tipo,'numero_cuenta' => $numero_cuenta,'id_usuario' =>$id_usuario); 
	$result = $client->call('AddDiscountsIncome',$param,'','','',true);

}
else
{

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