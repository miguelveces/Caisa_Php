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
	$id_jornada =isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  "";
	$codigo_jornada = isset($_POST['codworkingday']) ? mysqli_real_escape_string($connect, $_POST['codworkingday']) :  "";
	$descripcion = isset($_POST['description']) ? mysqli_real_escape_string($connect, $_POST['description']) :  "";
	$hora_inicia = isset($_POST['start']) ? mysqli_real_escape_string($connect, $_POST['start']) :  "";
	$hora_termina = isset($_POST['end']) ? mysqli_real_escape_string($connect, $_POST['end']) :  "";
	$total_horas = isset($_POST['totalhours']) ? mysqli_real_escape_string($connect, $_POST['totalhours']) :  "";
	$paga = isset($_POST['pay']) ? mysqli_real_escape_string($connect, $_POST['pay']) :  "";
	$id_turno = isset($_POST['idturn']) ? mysqli_real_escape_string($connect, $_POST['idturn']) :  "";
	$turno = isset($_POST['turn']) ? mysqli_real_escape_string($connect, $_POST['turn']) :  "";

    //Give it value at parameter 
     $param = array('id_jornada' => $id_jornada,'codigo_jornada' =>$codigo_jornada,'descripcion' => $descripcion,'hora_inicia' => $hora_inicia,
	'hora_termina' => $hora_termina,'total_horas' => $total_horas,'paga' => $paga,
	'id_turno' => $id_turno,'turno' => $turno);
	$result = $client->call('EditWorkingDayByid',$param,'','','',true);

}
else
{
$id_jornada = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
$param = array('id_jornada' => $id_jornada); 
$result = $client->call('GetWorkingDayByid',$param,'','','',true);



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
			if($result[0]['msg']=='OK')
			{
				$json = array("status" => 1, "info" => $result);
				
			}
			else
			{
				$json = array("status" => 0, "info" => $result);
				
				
			}
			echo json_encode($json);
         }
    }
}		
?>