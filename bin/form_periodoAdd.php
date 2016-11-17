<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultPeriod="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data

    //$id_empresa = isset($_POST['numcompany']) ? mysqli_real_escape_string($connect, $_POST['numcompany']) :  "";
	$anno_fiscal = isset($_POST['yearfiscal']) ? mysqli_real_escape_string($connect, $_POST['yearfiscal']) :  "";
	$frecuencia_pago = isset($_POST['payfrecuencia']) ? mysqli_real_escape_string($connect, $_POST['payfrecuencia']) :  "";
	$numero_control = isset($_POST['numbercontrol']) ? mysqli_real_escape_string($connect, $_POST['numbercontrol']) :  "";
	$numero_periodo = isset($_POST['numberperiodo']) ? mysqli_real_escape_string($connect, $_POST['numberperiodo']) :  "";
	$fecha_pago = isset($_POST['datepay']) ? mysqli_real_escape_string($connect, $_POST['datepay']) :  "";
	$fecha_inicio = isset($_POST['datei']) ? mysqli_real_escape_string($connect, $_POST['datei']) :  "";
	$fecha_final = isset($_POST['datef']) ? mysqli_real_escape_string($connect, $_POST['datef']) :  "";
	$secuencia_mensual = isset($_POST['secuence']) ? mysqli_real_escape_string($connect, $_POST['secuence']) :  "";
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";

    //Give it value at parameter 
    //$param = array(); 
	//$period = $client->call('GetAllPeriods',$param,'','','',true);
	//if($period[0]['id_periodo']!=null)
	//{
	$param = array(); 
	$resultPeriod = $client->call('EditPeriod',$param,'','','',true);
	//}
	$param = array('anno_fiscal' => $anno_fiscal,'frecuencia_pago' => $frecuencia_pago,'numero_control'=>$numero_control,
	'numero_periodo' => $numero_periodo,'fecha_pago' => $fecha_pago,'fecha_inicio' => $fecha_inicio,
	'fecha_final' => $fecha_final,'secuencia_mensual' => $secuencia_mensual,'estatus' => 1,'id_usuario' => $id_usuario); 
	$result = $client->call('AddPeriod',$param,'','','',true);

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