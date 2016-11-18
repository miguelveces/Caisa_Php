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
    // Get data

    //$id_empresa = isset($_POST['numcompany']) ? mysqli_real_escape_string($connect, $_POST['numcompany']) :  "";
	$id_dia_feriado = isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  "";
	$fecha_dia_feriado = isset($_POST['dayholiday']) ? mysqli_real_escape_string($connect, $_POST['dayholiday']) :  "";
	$celebracion = isset($_POST['celebration']) ? mysqli_real_escape_string($connect, $_POST['celebration']) :  "";
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";


    $param = array('id_dia_feriado' => $id_dia_feriado,'fecha_dia_feriado' => $fecha_dia_feriado,'celebracion' => $celebracion,'id_usuario' => $id_usuario); 
	$result = $client->call('EditDayHolidayByid',$param,'','','',true);

}
else
{
$id_dia_feriado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
$param = array('id_dia_feriado' => $id_dia_feriado); 
$result = $client->call('GetDayHolidayByid',$param,'','','',true);
 
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