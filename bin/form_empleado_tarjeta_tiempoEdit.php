<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultWorkingDays="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
	$id_jornada_empleado =isset($_POST['idworkingdayemployee']) ? mysqli_real_escape_string($connect, $_POST['idworkingdayemployee']) :  "";
	//$fecha = isset($_POST['dates']) ? mysqli_real_escape_string($connect, $_POST['dates']) :  "";
	//$dia = isset($_POST['day']) ? mysqli_real_escape_string($connect, $_POST['day']) :  "";
	$laboro = isset($_POST['iwork']) ? mysqli_real_escape_string($connect, $_POST['iwork']) :  "";
	$ausencia = isset($_POST['absence']) ? mysqli_real_escape_string($connect, $_POST['absence']) :  "";
	$tipo = isset($_POST['type']) ? mysqli_real_escape_string($connect, $_POST['type']) :  "";
	$codigo = isset($_POST['code']) ? mysqli_real_escape_string($connect, $_POST['code']) :  "";
	$codigo_jornada = isset($_POST['workingday']) ? mysqli_real_escape_string($connect, $_POST['workingday']) :  "";
	$com = isset($_POST['com']) ? mysqli_real_escape_string($connect, $_POST['com']) :  "";
	$hora_entra = isset($_POST['timeentry']) ? mysqli_real_escape_string($connect, $_POST['timeentry']) :  "";
	$hora_sale = isset($_POST['timeout']) ? mysqli_real_escape_string($connect, $_POST['timeout']) :  "";
	$horas_regulares = isset($_POST['regulartime']) ? mysqli_real_escape_string($connect, $_POST['regulartime']) :  "";
	$horas_extras = isset($_POST['extratime']) ? mysqli_real_escape_string($connect, $_POST['extratime']) :  "";



    //Give it value at parameter 
     $param = array('id_jornada_empleado' => $id_jornada_empleado,
	 'laboro' => $laboro,'ausencia' => $ausencia,'tipo' => $tipo,'codigo' => $codigo,
	 'codigo_jornada' => $codigo_jornada,'com' => $com,'hora_entra' => $hora_entra,'hora_sale' => $hora_sale,
	 'horas_regulares' => $horas_regulares,'horas_extras' => $horas_extras);
	$result = $client->call('EditWorkingDayEmployeeByid',$param,'','','',true);

}
else
{
$id_jornada_empleado = isset($_GET['idworkingdayemployee']) ? mysqli_real_escape_string($connect, $_GET['idworkingdayemployee']) :  "";
$param = array('id_jornada_empleado' => $id_jornada_empleado); 
$result = $client->call('GetWorkingDayEmployeeByid',$param,'','','',true);

$workingdays = $client->call('GetAllWorkingDays',$param,'','','',true);
foreach($workingdays as $workingday){ 
	$resultWorkingDays.='<option value='.$workingday['id_jornada'].' '.($workingday['codigo_jornada'] == $result[0]['codigo_jornada'] ? 'selected="selected"' : "").'>'.$workingday['codigo_jornada'].'</option>';
	
} 


 header('Content-type: application/json');
 $json = array("status" => 1, "info" => $result, "workingdays"=>$resultWorkingDays, "infoworkingdays"=>$workingdays);
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