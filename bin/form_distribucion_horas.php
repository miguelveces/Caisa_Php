<?php
session_start();
//require_once ('lib/nusoap.php'); 
require_once ('../../WSCaisa/lib/nusoap.php'); 
//$wsdl= "http://". $_SERVER['SERVER_NAME']."/WSCaisa/MyService.php?wsdl";
$wsdl= "http://". $_SERVER['SERVER_NAME']."/demos/WSCaisa/MyService.php?wsdl";

//Create object that referer a web services 
$client = new nusoap_client($wsdl,true); 
$result="";
$resultperiods="";
$resultEmployee="";
$resultNumberPeriod="";
$resultEmployeeRecordTransaction="";
$horas_regular="";
$horas_domingo="";
$horas_feriado="";
$horas_compensatorio="";
$tmpyear="";
$tmpperiod="";
$param = array(); 
$connect=mysqli_connect("localhost","UserCaisa","UserCaisa","planillas");
if($_SERVER['REQUEST_METHOD'] == "POST"){

	$id_empresa = isset($_SESSION['id_empresa']) ? mysqli_real_escape_string($connect, $_SESSION['id_empresa']) :  "";
	$id_periodo = isset($_POST['id']) ? mysqli_real_escape_string($connect, $_POST['id']) :  ""; 
	$anno_fiscal = isset($_POST['yearfiscal']) ? mysqli_real_escape_string($connect, $_POST['yearfiscal']) :  "";
	
	
	$param = array('id_empresa' => $id_empresa); 
	$employees = $client->call('GetEmployeeByidCompany',$param,'','','',true);
    
	//$param = array('id_periodo' => $id_periodo); 
	//$periods = $client->call('GetPeriodByid',$param,'','','',true);
    
	foreach($employees as $employee){ 
		$id_empleado=$employee['id_empleado'];
		$horas_regular="104.00";$horas_domingo="0.00";$horas_feriado="0.00";$horas_compensatorio="0.00";
		$horas_extra1="0.00";$horas_extra2="0.00";$horas_extra3="0.00";$horas_extra4="0.00";$horas_extra5="0.00";
		$horas_extra6="0.00";$horas_extra7="0.00";$horas_extra8="0.00";$horas_extra9="0.00";$horas_extra10="0.00";
		$factor_reg="1.0000";$factor_dom="1.5000";$factor_fer="2.5000";$factor_com="0.5000"; 
		$factor1="0.0000";$factor2="0.0000";$factor3="0.0000"; $factor4="0.0000";$factor5="0.0000";
		$factor6="0.0000";$factor7="0.0000";$factor8="0.0000";$factor9="0.0000";$factor10="0.0000";
		$horas_enferm="0.00";$horas_ajuste="0.00";$horas_ausen="0.00";$horas_certmedic="0.00";$adelanto_vacaciones="0.00";
		
		$param = array('id_empleado' => $id_empleado,'id_periodo' => $id_periodo,'anno_fiscal' => $anno_fiscal); 
		$workingdayemployees= $client->call('GetWorkingDayEmployeeByPeriod',$param,'','','',true);

		
		if($workingdayemployees[0]['id_jornada_empleado']!=null) 
		{
			$horas_regular="0.00";
			foreach($workingdayemployees as $wdayemployee){ 
				if($wdayemployee['laboro']==1){
					if($wdayemployee['tipo']=='R'){
						$horas_regular=$horas_regular+$wdayemployee['horas_regulares'];
						$horas_regular =number_format((float)$horas_regular, 2, '.', ''); 
					}elseif($wdayemployee['tipo']=='D'){
						$horas_domingo=$horas_domingo+$wdayemployee['horas_regulares'];
						$horas_domingo =number_format((float)$horas_domingo, 2, '.', ''); 
					}elseif($wdayemployee['tipo']=='F'){
						$horas_feriado=$horas_feriado+$wdayemployee['horas_regulares'];
						$horas_feriado =number_format((float)$horas_feriado, 2, '.', ''); 
					}
					else{
						$horas_compensatorio=$horas_compensatorio+$wdayemployee['horas_regulares'];
						$horas_compensatorio =number_format((float)$horas_compensatorio, 2, '.', ''); 
					}
				}
			}
			
		}
		$param = array('id_empleado' => $id_empleado,'id_empresa' => $id_empresa,'id_periodo' => $id_periodo,
					 'horas_regular' => $horas_regular, 'horas_domingo' => $horas_domingo, 
					  'horas_feriado' => $horas_feriado, 'horas_compensatorio' => $horas_compensatorio,
					  'horas_extra1' => $horas_extra1,'horas_extra2' => $horas_extra2, 'horas_extra3' => $horas_extra3, 'horas_extra4' => $horas_extra4, 'horas_extra5' => $horas_extra5,
					  'horas_extra6' => $horas_extra6,'horas_extra7' => $horas_extra7, 'horas_extra8' => $horas_extra8, 'horas_extra9' => $horas_extra9, 'horas_extra10' => $horas_extra10,
					  'factor_reg' => $factor_reg,'factor_dom' => $factor_dom, 'factor_fer' => $factor_fer, 'factor_com' => $factor_com, 
					  'factor1' => $factor1, 'factor2' => $factor2, 'factor3' => $factor3, 'factor4' => $factor4, 'factor5' => $factor5,
					  'factor6' => $factor6, 'factor7' => $factor7, 'factor8' => $factor8, 'factor9' => $factor9, 'factor10' => $factor10,
					   'horas_enferm' => $horas_enferm, 'horas_ajuste' => $horas_ajuste, 'horas_ausen' => $horas_ausen, 'horas_certmedic' => $horas_certmedic, 'adelanto_vacaciones' => $adelanto_vacaciones);
				$result= $client->call('AddEmployeeRecordTransaction',$param,'','','',true);

			
	}
	 
	
}
else
{
    
	$param = array(); 
	$result = $client->call('GetPeriodByStatus',$param,'','','',true);

		header('Content-type: application/json');
		$json = array("status" => 1,"info" => $result);
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