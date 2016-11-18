<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";


//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$resultInforme="";
$param = array();
$result=array();
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");

  //Give it value at parameter 
	$id_periodo = isset($_GET['id']) ? mysqli_real_escape_string($connect, $_GET['id']) :  "";
	$id_empresa = isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  ""; 	
	$param = array('id_empresa' => $id_empresa,'id_periodo' => $id_periodo); 
	$resultInforme = $client->call('GetInformeBankEmployeesByid',$param,'','','',true); 
	 

$filename = "informebanco.csv";
$fp = fopen('php://output', 'w');
//$file = fopen("contacts.csv","w");
header('Content-type: application/csv');
header('Content-Disposition: attachment; filename='.$filename);
//fputcsv($fp);  str_replace('""', '', $informe['apellido_empleado'].' '.$informe['nombre_empleado'])
foreach($resultInforme as $informe){ 
		//$result[] = array($informe['numero_empleado'],$informe['apellido_empleado'],$informe['nombre_empleado'],$informe['id_banco'],$informe['numero_cuenta'],$informe['id_tipo_cuenta'],$informe['salario_neto'],'C','REF*TXT** PERIODO DE PAGO # '); 
	   fputcsv($fp,array($informe['numero_empleado'],$informe['apellido_empleado'].' '.$informe['nombre_empleado'],$informe['id_banco'],$informe['numero_cuenta'],$informe['id_tipo_cuenta'],$informe['salario_neto'],'C','REF*TXT** PERIODO DE PAGO # \\'));
} 
fclose($fp); 

?>



