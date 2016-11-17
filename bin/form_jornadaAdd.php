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

    $codigo_jornada = isset($_POST['codworkingday']) ? mysqli_real_escape_string($connect, $_POST['codworkingday']) :  "";
	$descripcion = isset($_POST['description']) ? mysqli_real_escape_string($connect, $_POST['description']) :  "";
	$hora_inicia = isset($_POST['start']) ? mysqli_real_escape_string($connect, $_POST['start']) :  "";
	$hora_termina = isset($_POST['end']) ? mysqli_real_escape_string($connect, $_POST['end']) :  "";
	$total_horas = isset($_POST['totalhours']) ? mysqli_real_escape_string($connect, $_POST['totalhours']) :  "";
	$paga = isset($_POST['pay']) ? mysqli_real_escape_string($connect, $_POST['pay']) :  "";
	$id_turno = isset($_POST['idturn']) ? mysqli_real_escape_string($connect, $_POST['idturn']) :  "";
	$turno = isset($_POST['turn']) ? mysqli_real_escape_string($connect, $_POST['turn']) :  "";

    //Give it value at parameter 
    $param = array('codigo_jornada'=> $codigo_jornada,'descripcion' => $descripcion,'hora_inicia' => $hora_inicia,
	'hora_termina' => $hora_termina,'total_horas' => $total_horas,'paga' => $paga,
	'id_turno' => $id_turno,'turno' => $turno); 
	$result = $client->call('AddWorkingDay',$param,'','','',true);

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