<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultGender="";
$resultStatesCivil="";
$resultStatesEmployee="";
$resultNationality="";
$resultPosition="";
$resultSectionsDepartments="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
    $numero_empleado = isset($_POST['employeenum']) ? mysqli_real_escape_string($connect, $_POST['employeenum']) :  ""; 
	$cedula = isset($_POST['identitycardnum']) ? mysqli_real_escape_string($connect, $_POST['identitycardnum']) :  "";
	$seguro_social = isset($_POST['socisecunum']) ? mysqli_real_escape_string($connect, $_POST['socisecunum']) :  ""; 
	$apellido = isset($_POST['lastnames']) ? mysqli_real_escape_string($connect, $_POST['lastnames']) :  ""; 
	$nombre = isset($_POST['names']) ? mysqli_real_escape_string($connect, $_POST['names']) :  ""; 
	$id_genero = isset($_POST['gender']) ? mysqli_real_escape_string($connect, $_POST['gender']) :  ""; 
	$id_nacionalidad = isset($_POST['nationality']) ? mysqli_real_escape_string($connect, $_POST['nationality']) :  "";
    $id_estado_civil = isset($_POST['statescivil']) ? mysqli_real_escape_string($connect, $_POST['statescivil']) :  ""; 	
	$fecha_nacimiento = isset($_POST['datebirth']) ? mysqli_real_escape_string($connect, $_POST['datebirth']) :  ""; 
	$tipo_sangre = isset($_POST['typeblood']) ? mysqli_real_escape_string($connect, $_POST['typeblood']) :  ""; 
	$id_estado_empleado = isset($_POST['statesemployee']) ? mysqli_real_escape_string($connect, $_POST['statesemployee']) :  ""; 
	$id_seccion = isset($_POST['secciondepart']) ? mysqli_real_escape_string($connect, $_POST['secciondepart']) :  ""; 
	$id_cargo = isset($_POST['position']) ? mysqli_real_escape_string($connect, $_POST['position']) :  ""; 
	$horas_x_periodo = isset($_POST['basehours']) ? mysqli_real_escape_string($connect, $_POST['basehours']) :  ""; 
	$rata_x_hora = isset($_POST['rathours']) ? mysqli_real_escape_string($connect, $_POST['rathours']) :  ""; 
	$salario = isset($_POST['salary']) ? mysqli_real_escape_string($connect, $_POST['salary']) :  ""; 
	$fecha_venc_contrato = isset($_POST['datecontract']) ? mysqli_real_escape_string($connect, $_POST['datecontract']) :  ""; 
	$fecha_venc_carnet= isset($_POST['datecarnet']) ? mysqli_real_escape_string($connect, $_POST['datecarnet']) :  ""; 
	$pago_efectivo = isset($_POST['payment']) ? mysqli_real_escape_string($connect, $_POST['payment']) :  ""; 
	$sindicato = isset($_POST['syndicate']) ? mysqli_real_escape_string($connect, $_POST['syndicate']) :  ""; 
	$clave_renta = isset($_POST['keyrent']) ? mysqli_real_escape_string($connect, $_POST['keyrent']) :  ""; 
	$forma_pago = isset($_POST['paymentm']) ? mysqli_real_escape_string($connect, $_POST['paymentm']) :  ""; 
	$frecuencia_pago = isset($_POST['paymentf']) ? mysqli_real_escape_string($connect, $_POST['paymentf']) :  ""; 
	$fecha_ingreso = isset($_POST['dateadmission']) ? mysqli_real_escape_string($connect, $_POST['dateadmission']) :  ""; 
	$fecha_prox_vacaciones = isset($_POST['dateholidays']) ? mysqli_real_escape_string($connect, $_POST['dateholidays']) :  ""; 
	$fecha_terminacion = isset($_POST['datetermination']) ? mysqli_real_escape_string($connect, $_POST['datetermination']) :  ""; 
	$isr_gasto = isset($_POST['isr']) ? mysqli_real_escape_string($connect, $_POST['isr']) :  "";
    $id_empresa = isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  ""; 	
    $id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
	//Give it value at parameter 
	$param = array('numero_empleado' =>	$numero_empleado,'cedula' => $cedula,'seguro_social' => $seguro_social,
					'apellido' => $apellido,'nombre' =>	$nombre,'id_genero' => $id_genero,'id_nacionalidad' => $id_nacionalidad,
					'id_estado_civil' => $id_estado_civil,'fecha_nacimiento' => $fecha_nacimiento,'tipo_de_sangre'=> $tipo_sangre,
					'id_estado_empleado' => $id_estado_empleado,'id_seccion' =>	$id_seccion,'id_cargo' => $id_cargo, 
					'horas_x_periodo' => $horas_x_periodo,'rata_x_hora' => $rata_x_hora,'salario' => $salario, 
					'fecha_vence_contrato' => $fecha_venc_contrato,'fecha_venc_carnet' => $fecha_venc_carnet,'pago_efectivo' => $pago_efectivo, 
					'sindicato' => $sindicato,'clave_renta' =>	$clave_renta,'forma_pago' => $forma_pago,
					'frecuencia_pago' => $frecuencia_pago,'fecha_ingreso' => $fecha_ingreso,'fecha_prox_vacaciones' => $fecha_prox_vacaciones,
					'fecha_terminacion '=> $fecha_terminacion,'isr_gasto' => $isr_gasto,'id_empresa' => $id_empresa);

	
	$result = $client->call('AddEmployee',$param,'','','',true);

	
	

	//prueba de datos**************************************************************************************************//
	//*****************************************************************************************************************//
	     /* $result=$param;
		   header('Content-type: application/json');
		   $json = array("status" => 1, "info" => $result);
			echo json_encode($json);
			exit();*/
	
	//*****************************************************************************************************************//
	
	
	
}
else
{
    $genders = $client->call('GetAllGenders',$param,'','','',true);
	foreach($genders as $gender){ 
		$resultGender.='<option value='.$gender['id_genero'].'>'.$gender['nombre_genero'].'</option>';
	} 
	
	$statescivil = $client->call('GetAllStatesCivil',$param,'','','',true); 
	foreach($statescivil as $statecivil){ 
		$resultStatesCivil.='<option value='.$statecivil['id_estado_civil'].'>'.$statecivil['nombre_estado_civil'].'</option>';
	} 
	
	$statesemployees = $client->call('GetAllStatesEmployees',$param,'','','',true);
	foreach($statesemployees as $stateemployees){ 
		$resultStatesEmployee.='<option value='.$stateemployees['id_estado_empleado'].'>'.$stateemployees['nombre_estado_empleado'].'</option>';
	} 
	
	$nationalities = $client->call('GetAllNationalities',$param,'','','',true); 
	foreach($nationalities as $nationality){ 
		$resultNationality.='<option value='.$nationality['id_nacionalidad'].'>'.$nationality['nacionalidad'].'</option>';
	} 
	$positions = $client->call('GetAllPositions',$param,'','','',true);
	foreach($positions as $position){ 
		$resultPosition.='<option value='.$position['id_cargo'].'>'.$position['nombre_cargo'].'</option>';
	} 
	$sectionsdepart = $client->call('GetAllSectionsDepartments',$param,'','','',true);
	foreach($sectionsdepart as $sectionsdep){ 
		$resultSectionsDepartments.='<option value='.$sectionsdep['id_seccion'].'>'.$sectionsdep['nombre_seccion'].' / '.$sectionsdep['nombre_departamento'].'</option>';
	} 
 header('Content-type: application/json');
 $json = array("status" => 1, "gender" => $resultGender, "statescivil" => $resultStatesCivil, "statesemployee" => $resultStatesEmployee, "nationality" => $resultNationality, "position" => $resultPosition,"sectionsdepart" => $resultSectionsDepartments);
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
			if($resultLegalTaxEmployee[0]['msg']=='OK')
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