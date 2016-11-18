<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultDiscountsIncome="";
$resultSectionsDepartments="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){
    // Get data
	$id_empleado = isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  "";
    $numero_cliente = isset($_POST['customernum']) ? mysqli_real_escape_string($connect, $_POST['customernum']) :  ""; 
	$numero_cuenta = isset($_POST['bankaccount']) ? mysqli_real_escape_string($connect, $_POST['bankaccount']) :  "";
	$numero_empleado = isset($_POST['employeenum']) ? mysqli_real_escape_string($connect, $_POST['employeenum']) :  ""; 
	$id_descuento_ingreso = isset($_POST['discountincome']) ? mysqli_real_escape_string($connect, $_POST['discountincome']) :  ""; 
	$monto_mes = isset($_POST['amountpermonth']) ? mysqli_real_escape_string($connect, $_POST['amountpermonth']) :  "";
	$monto_mes =number_format((float)$monto_mes, 2, '.', ''); 	
	//$monto_periodo = isset($_POST['amountperperiod']) ? mysqli_real_escape_string($connect, $_POST['amountperperiod']) :  "";
	$monto_periodo =number_format((float)($monto_mes/2), 2, '.', ''); 
    $afecta_diciembre = isset($_POST['afectdecember']) ? mysqli_real_escape_string($connect, $_POST['afectdecember']) :  ""; 	
	$prioridad = isset($_POST['priority']) ? mysqli_real_escape_string($connect, $_POST['priority']) :  ""; 
	$tipo = isset($_POST['type']) ? mysqli_real_escape_string($connect, $_POST['type']) :  ""; 
	$frecuencia = isset($_POST['frequency']) ? mysqli_real_escape_string($connect, $_POST['frequency']) :  ""; 
	$monto_urgente = isset($_POST['amounturgent']) ? mysqli_real_escape_string($connect, $_POST['amounturgent']) :  "";
	//$monto_urgente =number_format((float)$monto_urgente, 2, '.', ''); 
	$monto_urgente =($monto_urgente!="")? number_format((float)$monto_urgente, 2, '.', ''):  "";
	$monto_original = isset($_POST['amountoriginal']) ? mysqli_real_escape_string($connect, $_POST['amountoriginal']) :  "";
	$monto_original =number_format((float)$monto_original, 2, '.', ''); 	
	//$monto_pendiente = isset($_POST['amountoutstanding']) ? mysqli_real_escape_string($connect, $_POST['amountoutstanding']) :  "";
	$monto_pendiente = $monto_original;
	$estado = 1;
	$fecha_ultimo_pago = '0000-00-00';
	$cantidad_pago = 0;
	$referencia = isset($_POST['reference']) ? mysqli_real_escape_string($connect, $_POST['reference']) :  ""; 
	$id_usuario= isset($_SESSION['id_usuario']) ? mysqli_real_escape_string($connect, $_SESSION['id_usuario']) :  "";
	//Give it value at parameter 
	$param = array(); 
	$period = $client->call('GetPeriodByStatus',$param,'','','',true);
    $id_periodo=$period[0]['id_periodo'];
	
	$param = array('numero_cliente' =>$numero_cliente,'numero_cuenta' => $numero_cuenta,'numero_empleado' => $numero_empleado,
					'id_empleado' => $id_empleado,'id_descuento_ingreso' => $id_descuento_ingreso,'monto_mes' =>	$monto_mes,'monto_periodo' => $monto_periodo,
					'afecta_diciembre' => $afecta_diciembre,'prioridad' => $prioridad,'tipo' => $tipo,'frecuencia'=> $frecuencia,
					'monto_urgente' => $monto_urgente,'monto_original' => $monto_original,'monto_pendiente' => $monto_pendiente,'estado' => $estado,'referencia' => $referencia,
					'id_periodo' =>$id_periodo,'fecha_ultimo_pago' =>$fecha_ultimo_pago,'cantidad_pago' => $cantidad_pago,'id_usuario' => $id_usuario);
	$result = $client->call('AddDiscountsIncomeEmployee',$param,'','','',true);
    //$DiscountsIncomeEmployee 
	/*$id_descuento_ingreso_empleado=$DiscountsIncomeEmployee[0]['id']; 
	$param = array('id_descuento_ingreso_empleado' => $id_descuento_ingreso_empleado,'monto_mes' =>	$monto_mes,'monto_periodo' => $monto_periodo,
					'monto_original' => $monto_original,'monto_pendiente' => $monto_pendiente,'estado' => $estado,'id_periodo' =>$id_periodo,'id_usuario' => $id_usuario);
	$result = $client->call('AddDiscountsIncomeEmployeeDetail',$param,'','','',true);*/
	
	
}
else
{
    $id_empleado = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	$param = array('id_empleado' => $id_empleado); 
	$result = $client->call('GetEmployeeByid',$param,'','','',true);
  
	$sectionsdepart = $client->call('GetAllSectionsDepartments',$param,'','','',true);
	foreach($sectionsdepart as $sectionsdep){ 
		$resultSectionsDepartments.='<option value='.$sectionsdep['id_seccion'].' '.($sectionsdep['id_seccion'] == $result[0]['id_seccion'] ? 'selected="selected"' : "").'>'.$sectionsdep['nombre_seccion'].' / '.$sectionsdep['nombre_departamento'].'</option>';
	} 
    $discountsincome = $client->call('GetAllDiscountsIncome',$param,'','','',true); 
	foreach($discountsincome as $discountincome){ 
		$resultDiscountsIncome.='<option value='.$discountincome['id_descuento_ingreso'].'>'.$discountincome['cod_descuento_ingreso'].' / '.$discountincome['nombre_descuento_ingreso'].' / '.$discountincome['tipo'].' </option>';
	} 
	

 header('Content-type: application/json');
 $json = array("status" => 1,"info" => $result, "discountincome" => $resultDiscountsIncome,"sectionsdepart" => $resultSectionsDepartments);
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